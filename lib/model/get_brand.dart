// To parse this JSON data, do
//
//     final getBrand = getBrandFromJson(jsonString);

import 'dart:convert';

GetBrand getBrandFromJson(String str) => GetBrand.fromJson(json.decode(str));

String getBrandToJson(GetBrand data) => json.encode(data.toJson());

class GetBrand {
  String message;
  List<Datum> data;

  GetBrand({required this.message, required this.data});

  factory GetBrand.fromJson(Map<String, dynamic> json) => GetBrand(
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
