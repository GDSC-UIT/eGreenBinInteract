import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:egreenbin_interact/data/trashData.dart';
import 'package:egreenbin_interact/models/Gabage.dart';
import 'package:egreenbin_interact/util/app_colors.dart';
import 'package:egreenbin_interact/util/app_string.dart';
import 'package:egreenbin_interact/util/http_Service.dart';
import 'package:egreenbin_interact/widgets/pop_Incorrect.dart';
import 'package:egreenbin_interact/widgets/popup_Correct.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';

class ScanController extends GetxController {
  String espUrl = "ws://192.168.138.12:81";
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = RxBool(false);
  CameraImage? _cameraImage;
  Rx<File> imageTake = File("").obs;
  CameraController get cameraController => _cameraController;
  bool get isInitialized => _isInitialized.value;
  RxBool isGotFace = false.obs;
  bool isTakeImage = false;
  //create face detector object
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  int count = 1;
  RxString trashLabel = "".obs;
  AudioPlayer audioPlayer = AudioPlayer();
  IOWebSocketChannel? channel;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    _isInitialized.value = false;
    _cameraController.dispose();
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  void connectEsp(String espUrlInput) {
    try {
      espUrl = "ws://$espUrlInput:81";

      print("url:$espUrl");

      final channel = IOWebSocketChannel.connect(espUrl);
      print("channel:$channel");
      channel.stream.listen(
        (message) {
          print('Received from MCU: $message');
          String signal = message;
          log("debug $signal");
          if (signal == "0") {
            return;
          }
          switch (signal) {
            case "capture":
              {
                isTakeImage = true;
                break;
              }
            default:
              //catch trash label
              log("here");
              trashLabel.value = signal;
          }
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
        },
        onError: (error) {
          print(error.toString());
          throw const FormatException("Input not correct");
        },
      );
    } catch (e) {
      print("$e");
    }
  }

  void handleAction(choice) async {
    Garbage data = Garbage(
      code: "20521111",
      name: "Huu Hieu",
    );

    //check action
    if (choice == "recycle") {
      if (Data[trashLabel]["isRecycle"]) {
        data.isRight = true;
      }
      // print("right");
      // channel?.sink.add("right");
    } else {
      if (!Data[trashLabel]["isRecycle"]) {
        data.isRight = true;
      }
      // print("left");

      // channel?.sink.add("left");
    }

    try {
      if (data.isRight) {
        channel?.sink.add("right");
      } else {
        channel?.sink.add("left");
      }

      var response = await HttpService.postRequest(
          url: AppString.URLServer, body: data.toJson());
      showEffect(data.isRight);
      print("response: $response");
    } catch (e) {
      Get.snackbar(
        "error occur",
        "$e",
        colorText: AppColors.red,
        backgroundColor: AppColors.lightGrey,
      );
    }
  }

  void showEffect(isRight) async {
    if (!isRight) {
      await audioPlayer.play(AssetSource('audios/incorrect.mp3'));
      Get.dialog(const PopupInCorrect());
    } else {
      await audioPlayer.play(AssetSource('audios/correct.mp3'));
      Get.dialog(const PopupCorrect());
    }
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[1], ResolutionPreset.high);
    _cameraController.initialize().then((value) {
      _isInitialized.value = true;
      _cameraController.startImageStream(_processCameraImage);
      _isInitialized.refresh();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  Future _processCameraImage(CameraImage image) async {
    _cameraImage = image;
    if (isTakeImage) {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();
      final Size imageSize = Size(
        image.width.toDouble(),
        image.height.toDouble(),
      );
      final camera = _cameras[1];
      final imageRotation =
          InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
              InputImageRotation.rotation0deg;
      final inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw) ??
              InputImageFormat.nv21;

      final planeData = image.planes.map((final Plane plane) {
        return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width);
      }).toList();

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        inputImageData: inputImageData,
      );

      detectFace(inputImage);
    }
  }

  Future<void> detectFace(final InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    final faces = await _faceDetector.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null &&
        faces.isNotEmpty) {
      print("have face");
      print("take image");
      Future.delayed(const Duration(milliseconds: 200), () async {
        await capture();
        isTakeImage = false;
        isGotFace.value = true;

        try {
          print("path image: ${imageTake.value.path}");
          var response = await HttpService.postFile(
              AppString.URLAiRecognition, imageTake.value.path);

          print("name of chid: ${response}");
        } catch (e) {
          print("error: $e");
        }
      });
    }
    _isBusy = false;
  }

  img.Image _convertYUV420(CameraImage image) {
    var res = img.Image(image.width, image.height); // Create Image buffer

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0;
          planeOffset < image.height * image.width;
          planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        var newVal =
            shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        res.data[planeOffset + x] = newVal;
      }
    }

    return res;
  }

  void resetImage() {
    imageTake.value = File("");
    isTakeImage = false;
    isGotFace.value = false;
    trashLabel.value = "";
  }

  Future<void> capture() async {
    if (_cameraImage != null) {
      print("capture image");
      img.Image image = _convertYUV420(_cameraImage!);
      Uint8List list = Uint8List.fromList(img.encodeJpg(image));
      Directory tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image$count.png').create();
      count++;
      file.writeAsBytesSync(list);
      imageTake.value = file;
    }
  }
}
