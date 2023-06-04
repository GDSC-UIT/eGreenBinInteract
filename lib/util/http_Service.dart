import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<dynamic> postRequest(
      {required String url, required String body}) async {
    try {
      print("post request");
      return await http.post(Uri.parse(url), body: body);
    } catch (e) {
      return Future.error("$e");
    }
  }

  static Future<String> uploadImage(String url, File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    // Thêm file ảnh vào yêu cầu đa phần
    var imageStream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var multipartFile = http.MultipartFile('img_file', imageStream, length,
        filename: imageFile.path);

    request.files.add(multipartFile);

    // Gửi yêu cầu và xử lý phản hồi
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseString);

      print(
          'Upload thành công! Phản hồi: ${jsonResponse["predict_user_name"][0]}');
      return jsonResponse["predict_user_name"][0];
    } else {
      print(
          'Upload thất bại. Mã lỗi: ${await response.stream.bytesToString()}');
      return "unknown";
    }
  }

  // static Future<dynamic> postFile(String url, String filePath) async {
  //   try {
  //     var uri = Uri.parse(url);
  //     var request = http.MultipartRequest("POST", uri);
  //     request.files.add(http.MultipartFile.fromBytes(
  //       'img_file', // NOTE - this value must match the 'file=' at the start of -F
  //       File(filePath).readAsBytesSync(),
  //       contentType: MediaType(
  //         'image',
  //         'png',
  //       ),
  //     ));
  //     final response = await http.Response.fromStream(await request.send());

  //     if (response.statusCode == 200) {
  //       var decoded = json.decode(response.body);

  //       return decoded;
  //     } else {
  //       return "failed to post image";
  //     }
  //   } catch (e) {
  //     print("error $e");
  //   }
  // }

}
