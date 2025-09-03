// To parse this JSON data, do
//
//     final getProdukModel = getProdukModelFromJson(jsonString);

import 'dart:convert';

GetProdukModel getProdukModelFromJson(String str) =>
    GetProdukModel.fromJson(json.decode(str));

String getProdukModelToJson(GetProdukModel data) => json.encode(data.toJson());

class GetProdukModel {
  String message;
  List<Detail> data;

  GetProdukModel({required this.message, required this.data});

  factory GetProdukModel.fromJson(Map<String, dynamic> json) => GetProdukModel(
    message: json["message"],
    data: List<Detail>.from(json["data"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Detail {
  int id;
  String name;
  String description;
  String price;
  String stock;
  String discount;
  String? category;
  String? categoryId;
  String? brand;
  String? brandId;
  List<String> imageUrls;
  List<String> imagePaths;

  Detail({
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

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    stock: json["stock"],
    discount: json["discount"],
    category: json["category"],
    categoryId: json["category_id"],
    brand: json["brand"],
    brandId: json["brand_id"],
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
