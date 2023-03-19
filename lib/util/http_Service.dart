import 'dart:convert';

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

  static Future<dynamic> postFile(String url, String filePath) async {
    final urlReq = Uri.parse(url);
    var request = http.MultipartRequest('POST', urlReq);
    // Attach the file in the request
    var file = await http.MultipartFile.fromPath('img_file', filePath);
    request.files.add(file);

    // Convert multipart request to JSON
    final requestBody = <String, dynamic>{'img_file': file};
    final jsonBody = jsonEncode(requestBody);

    // Send the request
    final response = await http.post(
      urlReq,
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    print("response:${response.body}");
    // Check the status code of the response
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print('File upload failed');
    }
  }
}
