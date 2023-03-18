import 'dart:convert';

class Garbage {
  String code;
  String name;
  bool isRight;

  Garbage({
    required this.code,
    required this.name,
    this.isRight = false,
  });

  String toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    data["name"] = name;
    data["isRight"] = isRight;
    return jsonEncode(data);
  }
}
