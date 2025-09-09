// To parse this JSON data, do
//
//     final addReviewModel = addReviewModelFromJson(jsonString);

import 'dart:convert';

AddReviewModel addReviewModelFromJson(String str) =>
    AddReviewModel.fromJson(json.decode(str));

String addReviewModelToJson(AddReviewModel data) => json.encode(data.toJson());

class AddReviewModel {
  String message;
  Rating data;

  AddReviewModel({required this.message, required this.data});

  factory AddReviewModel.fromJson(Map<String, dynamic> json) => AddReviewModel(
    message: json["message"],
    data: Rating.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Rating {
  int userId;
  int productId;
  int transactionId;
  int rating;
  String review;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  Rating({
    required this.userId,
    required this.productId,
    required this.transactionId,
    required this.rating,
    required this.review,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    userId: json["user_id"],
    productId: json["product_id"],
    transactionId: json["transaction_id"],
    rating: json["rating"],
    review: json["review"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "product_id": productId,
    "transaction_id": transactionId,
    "rating": rating,
    "review": review,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}
