// To parse this JSON data, do
//
//     final addCheckOutModel = addCheckOutModelFromJson(jsonString);

import 'dart:convert';

AddCheckOutModel addCheckOutModelFromJson(String str) =>
    AddCheckOutModel.fromJson(json.decode(str));

String addCheckOutModelToJson(AddCheckOutModel data) =>
    json.encode(data.toJson());

class AddCheckOutModel {
  String message;
  CheckOut data;

  AddCheckOutModel({required this.message, required this.data});

  factory AddCheckOutModel.fromJson(Map<String, dynamic> json) =>
      AddCheckOutModel(
        message: json["message"],
        data: CheckOut.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class CheckOut {
  int userId;
  List<Item> items;
  int total;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  CheckOut({
    required this.userId,
    required this.items,
    required this.total,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory CheckOut.fromJson(Map<String, dynamic> json) => CheckOut(
    userId: json["user_id"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    total: json["total"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "total": total,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}

class Item {
  BuyNow product;
  String quantity;

  Item({required this.product, required this.quantity});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    product: BuyNow.fromJson(json["product"]),
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "quantity": quantity,
  };
}

class BuyNow {
  int id;
  String name;
  String price;

  BuyNow({required this.id, required this.name, required this.price});

  factory BuyNow.fromJson(Map<String, dynamic> json) =>
      BuyNow(id: json["id"], name: json["name"], price: json["price"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "price": price};
}
