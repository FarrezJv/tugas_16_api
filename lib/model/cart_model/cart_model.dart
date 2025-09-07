// To parse this JSON data, do
//
//     final addCartModel = addCartModelFromJson(jsonString);

import 'dart:convert';

AddCartModel addCartModelFromJson(String str) =>
    AddCartModel.fromJson(json.decode(str));

String addCartModelToJson(AddCartModel data) => json.encode(data.toJson());

class AddCartModel {
  String message;
  CartDetail data;

  AddCartModel({required this.message, required this.data});

  factory AddCartModel.fromJson(Map<String, dynamic> json) => AddCartModel(
    message: json["message"],
    data: CartDetail.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class CartDetail {
  int userId;
  int productId;
  int quantity;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  CartDetail({
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory CartDetail.fromJson(Map<String, dynamic> json) => CartDetail(
    userId: json["user_id"] is String
        ? int.parse(json["user_id"])
        : json["user_id"],
    productId: json["product_id"] is String
        ? int.parse(json["product_id"])
        : json["product_id"],
    quantity: json["quantity"] is String
        ? int.parse(json["quantity"])
        : json["quantity"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"] is String ? int.parse(json["id"]) : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "product_id": productId,
    "quantity": quantity,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
