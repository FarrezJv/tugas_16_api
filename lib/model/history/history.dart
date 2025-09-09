// To parse this JSON data, do
//
//     final getHistoryModel = getHistoryModelFromJson(jsonString);

import 'dart:convert';

GetHistoryModel getHistoryModelFromJson(String str) =>
    GetHistoryModel.fromJson(json.decode(str));

String getHistoryModelToJson(GetHistoryModel data) =>
    json.encode(data.toJson());

class GetHistoryModel {
  String message;
  List<Kultum> data;

  GetHistoryModel({required this.message, required this.data});

  factory GetHistoryModel.fromJson(Map<String, dynamic> json) =>
      GetHistoryModel(
        message: json["message"],
        data: List<Kultum>.from(json["data"].map((x) => Kultum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Kultum {
  int id;
  String total;
  DateTime createdAt;
  List<Goods> items;

  Kultum({
    required this.id,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory Kultum.fromJson(Map<String, dynamic> json) => Kultum(
    id: json["id"],
    total: json["total"],
    createdAt: DateTime.parse(json["created_at"]),
    items: List<Goods>.from(json["items"].map((x) => Goods.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total": total,
    "created_at": createdAt.toIso8601String(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Goods {
  Product product;
  String quantity;
  bool hasReviewed;

  Goods({
    required this.product,
    required this.quantity,
    required this.hasReviewed,
  });

  factory Goods.fromJson(Map<String, dynamic> json) => Goods(
    product: Product.fromJson(json["product"]),
    quantity: json["quantity"],
    hasReviewed: json["has_reviewed"],
  );

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "quantity": quantity,
    "has_reviewed": hasReviewed,
  };
}

class Product {
  int id;
  String name;
  String price;

  Product({required this.id, required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(id: json["id"], name: json["name"], price: json["price"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "price": price};
}
