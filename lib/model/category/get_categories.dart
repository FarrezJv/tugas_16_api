// To parse this JSON data, do
//
//     final getCatModel = getCatModelFromJson(jsonString);

import 'dart:convert';

GetCatModel getCatModelFromJson(String str) =>
    GetCatModel.fromJson(json.decode(str));

String getCatModelToJson(GetCatModel data) => json.encode(data.toJson());

class GetCatModel {
  String message;
  List<GetCat> data;

  GetCatModel({required this.message, required this.data});

  factory GetCatModel.fromJson(Map<String, dynamic> json) => GetCatModel(
    message: json["message"],
    data: List<GetCat>.from(json["data"].map((x) => GetCat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GetCat {
  int? id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  GetCat({
    this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetCat.fromJson(Map<String, dynamic> json) => GetCat(
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
