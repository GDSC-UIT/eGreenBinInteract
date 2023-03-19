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
}
