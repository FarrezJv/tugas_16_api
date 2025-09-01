// To parse this JSON data, do
//
//     final addBrand = addBrandFromJson(jsonString);

import 'dart:convert';

AddBrand addBrandFromJson(String str) => AddBrand.fromJson(json.decode(str));

String addBrandToJson(AddBrand data) => json.encode(data.toJson());

class AddBrand {
  String message;
  AddBrandData data;

  AddBrand({required this.message, required this.data});

  factory AddBrand.fromJson(Map<String, dynamic> json) => AddBrand(
    message: json["message"],
    data: AddBrandData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class AddBrandData {
  String name;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  AddBrandData({
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory AddBrandData.fromJson(Map<String, dynamic> json) => AddBrandData(
    name: json["name"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
