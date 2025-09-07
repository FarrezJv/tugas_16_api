// To parse this JSON data, do
//
//     final getCartModel = getCartModelFromJson(jsonString);

import 'dart:convert';

GetCartModel getCartModelFromJson(String str) =>
    GetCartModel.fromJson(json.decode(str));

String getCartModelToJson(GetCartModel data) => json.encode(data.toJson());

class GetCartModel {
  String message;
  List<GetCart> data;

  GetCartModel({required this.message, required this.data});

  factory GetCartModel.fromJson(Map<String, dynamic> json) => GetCartModel(
    message: json["message"],
    data: List<GetCart>.from(json["data"].map((x) => GetCart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GetCart {
  int id;
  Product product;
  int quantity;
  int subtotal;
  // bool selected;

  GetCart({
    required this.id,
    required this.product,
    required this.quantity,
    required this.subtotal,
    // this.selected = false,
  });

  factory GetCart.fromJson(Map<String, dynamic> json) => GetCart(
    id: json["id"],
    product: Product.fromJson(json["product"]),
    quantity: json["quantity"] is String
        ? int.parse(json["quantity"])
        : json["quantity"],
    subtotal: json["subtotal"] is String
        ? int.parse(json["subtotal"])
        : json["subtotal"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product.toJson(),
    "quantity": quantity,
    "subtotal": subtotal,
  };
}

class Product {
  int id;
  String name;
  String description;
  String price;
  String stock;
  String discount;
  String category;
  int categoryId;
  String brand;
  int brandId;
  List<String> imageUrls;
  List<String> imagePaths;

  Product({
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

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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
