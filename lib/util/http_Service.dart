import 'package:http/http.dart' as http;

const URL = "https://egreenbin.onrender.com/api/garbage";

class HttpService {
  static Future<dynamic> postRequest({required String body}) async {
    try {
      print("post request");
      return await http.post(Uri.parse(URL), body: body);
    } catch (e) {
      return Future.error("$e");
    }
  }
}
