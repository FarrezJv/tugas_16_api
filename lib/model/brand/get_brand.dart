// To parse this JSON data, do
//
//     final getBrand = getBrandFromJson(jsonString);

import 'dart:convert';

GetBrand getBrandFromJson(String str) => GetBrand.fromJson(json.decode(str));

String getBrandToJson(GetBrand data) => json.encode(data.toJson());

class GetBrand {
  String? message;
  List<GetBrandData> data;

  GetBrand({this.message, required this.data});

  factory GetBrand.fromJson(Map<String, dynamic> json) => GetBrand(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<GetBrandData>.from(
            json["data"]!.map((x) => GetBrandData.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GetBrandData {
  int? id;
  String? name;
  String? imageUrl;
  String? imagePath;

  GetBrandData({this.id, this.name, this.imageUrl, this.imagePath});

  factory GetBrandData.fromJson(Map<String, dynamic> json) => GetBrandData(
    id: json["id"],
    name: json["name"],
    imageUrl: json["image_url"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image_url": imageUrl,
    "image_path": imagePath,
  };
}
