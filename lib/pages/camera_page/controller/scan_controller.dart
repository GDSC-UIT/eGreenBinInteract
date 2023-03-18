import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';

class ScanController extends GetxController {
  final RxBool _isInitialized = RxBool(false);
  bool get isInitialized => _isInitialized.value;
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  CameraController get cameraController => _cameraController;
  CameraImage? _cameraImage;
  bool _canProcess = true;
  bool _isBusy = false;
  //create face detector object
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool isTakeImage = false;
  RxBool isGotFace = false.obs;
  Rx<File> imageTake = File("").obs;
  RxString trashLabel = "".obs;
  int count = 1;

  void dispose() {
    _isInitialized.value = false;
    super.dispose();
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

    //detect here
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

      if (isTakeImage) {
        Future.delayed(const Duration(milliseconds: 500), () {
          capture();
          isTakeImage = false;
          isGotFace.value = true;
        });
      }
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
