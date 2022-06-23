// To parse this JSON data, do
//
//     final leave = leaveFromJson(jsonString);

import 'dart:convert';

Leave leaveFromJson(String str) => Leave.fromJson(json.decode(str));

String leaveToJson(Leave data) => json.encode(data.toJson());

class Leave {
  Leave({
    required this.leaveDate,
    required this.leaveFor,
    required this.signature,
  });

  String leaveDate;
  String leaveFor;
  String signature;

  factory Leave.fromJson(Map<String, dynamic> json) => Leave(
        leaveDate: json["LeaveDate"],
        leaveFor: json["LeaveFor"],
        signature: json["Signature"],
      );

  Map<String, dynamic> toJson() => {
        "LeaveDate": leaveDate,
        "LeaveFor": leaveFor,
        "Signature": signature,
      };
}
