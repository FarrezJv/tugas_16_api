import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tugas_16_api/api/endpoint/endpoint.dart';
import 'package:tugas_16_api/model/delete_model.dart';
import 'package:tugas_16_api/model/products/tambah_produk.dart';
import 'package:tugas_16_api/model/products/tampil_produk.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';

class AuthenticationApiProduct {
  static Future<AddProdukModel> addProduct({
    required String name,
    required String description,
    required int price,
    required int stock,
    required int brandId,
    required int categoryId,
    required int discount,
    required List<String> images,
  }) async {
    final url = Uri.parse(Endpoint.products);
    final token = await PreferenceHandler.getToken();
    final response = await http.post(
      url,
      body: jsonEncode({
        "name": name,
        "description": description,
        "price": price,
        "stock": stock,
        "brand_id": brandId,
        "category_id": categoryId,
        "discount": discount,
        "images": images,
      }),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return AddProdukModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to add new cart");
    }
  }

  static Future<GetProdukModel> updateProduct({required String name}) async {
    final url = Uri.parse(Endpoint.products);
    final token = await PreferenceHandler.getToken();
    final response = await http.put(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetProdukModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Data is not valid");
    }
  }

  static Future<GetProdukModel> getProduct() async {
    final url = Uri.parse(Endpoint.products);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetProdukModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to get product");
    }
  }

  static Future<DeleteModel> deleteProducts({
    required String name,
    required int id,
  }) async {
    final url = Uri.parse("${Endpoint.products}/$id");
    final token = await PreferenceHandler.getToken();
    final response = await http.delete(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return DeleteModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<GetProdukModel> postFotoProduct({
    required String name,
    required File image,
  }) async {
    final url = Uri.parse(Endpoint.products);
    final token = await PreferenceHandler.getToken();
    final readImage = image.readAsBytesSync();
    final b64 = base64Encode(readImage);
    final response = await http.post(
      url,
      body: {"name": name, "image_base64": b64},
      headers: {
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(image);
    print(readImage);
    print(b64);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return GetProdukModel.fromJson(json.decode(response.body)["data"]);
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }
}
