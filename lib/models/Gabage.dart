import 'dart:convert';

class Garbage {
  String studentID;
  String name;
  String trashLabel;
  bool isRight;

  Garbage({
    required this.studentID,
    required this.name,
    required this.trashLabel,
    this.isRight = false,
  });

  String toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data["studentID"] = studentID;
    data["name"] = name;
    data["isRight"] = isRight;
    data["trashLabel"] = trashLabel;
    return jsonEncode(data);
  }
}
