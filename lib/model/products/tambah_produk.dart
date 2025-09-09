// To parse this JSON data, do
//
//     final addProdukModel = addProdukModelFromJson(jsonString);

import 'dart:convert';

AddProdukModel addProdukModelFromJson(String str) =>
    AddProdukModel.fromJson(json.decode(str));

String addProdukModelToJson(AddProdukModel data) => json.encode(data.toJson());

class AddProdukModel {
  String message;
  GetProducts data;

  AddProdukModel({required this.message, required this.data});

  factory AddProdukModel.fromJson(Map<String, dynamic> json) => AddProdukModel(
    message: json["message"],
    data: GetProducts.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class GetProducts {
  int id;
  String name;
  String description;
  int price;
  int stock;
  int discount;
  String category;
  int categoryId;
  String brand;
  int brandId;
  List<String> imageUrls;
  List<String> imagePaths;

  GetProducts({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.discount,
    required this.category,
    required this.categoryId,
    required this.brand,
    required this.brandId,
    required this.imageUrls,
    required this.imagePaths,
  });

  factory GetProducts.fromJson(Map<String, dynamic> json) => GetProducts(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"] is String
        ? int.tryParse(json["price"]) ?? 0
        : json["price"] ?? 0,
    stock: json["stock"] is String
        ? int.tryParse(json["stock"]) ?? 0
        : json["stock"] ?? 0,
    discount: json["discount"] is String
        ? int.tryParse(json["discount"]) ?? 0
        : json["discount"] ?? 0,
    category: json["category"],
    categoryId: json["category_id"] is String
        ? int.tryParse(json["category_id"]) ?? 0
        : json["category_id"] ?? 0,
    brand: json["brand"],
    brandId: json["brand_id"] is String
        ? int.tryParse(json["brand_id"]) ?? 0
        : json["brand_id"] ?? 0,
    imageUrls: List<String>.from(json["image_urls"].map((x) => x)),
    imagePaths: List<String>.from(json["image_paths"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "discount": discount,
    "category": category,
    "category_id": categoryId,
    "brand": brand,
    "brand_id": brandId,
    "image_urls": List<dynamic>.from(imageUrls.map((x) => x)),
    "image_paths": List<dynamic>.from(imagePaths.map((x) => x)),
  };
}
