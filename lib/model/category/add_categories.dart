// To parse this JSON data, do
//
//     final addCategoriesModel = addCategoriesModelFromJson(jsonString);

import 'dart:convert';

AddCategoriesModel addCategoriesModelFromJson(String str) =>
    AddCategoriesModel.fromJson(json.decode(str));

String addCategoriesModelToJson(AddCategoriesModel data) =>
    json.encode(data.toJson());

class AddCategoriesModel {
  String message;
  AddCat data;

  AddCategoriesModel({required this.message, required this.data});

  factory AddCategoriesModel.fromJson(Map<String, dynamic> json) =>
      AddCategoriesModel(
        message: json["message"],
        data: AddCat.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class AddCat {
  String name;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  AddCat({
    required this.name,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory AddCat.fromJson(Map<String, dynamic> json) => AddCat(
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
