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
    required int prices,
    required int stock,
    required int categoryId,
    required int brandId,
    required int discount,
    required List<File> images,
  }) async {
    final url = Uri.parse(Endpoint.products);
    final token = await PreferenceHandler.getToken();

    List<String> base64Images = [];
    for (var img in images) {
      final bytes = await img.readAsBytes();
      final base64Str =
          "data:image/${img.path.split('.').last};base64,${base64Encode(bytes)}";
      base64Images.add(base64Str);
    }

    final response = await http.post(
      url,
      body: jsonEncode({
        "name": name,
        "description": description,
        "price": prices.toString(),
        "stock": stock.toString(),
        "category_id": categoryId.toString(),
        "brand_id": brandId.toString(),
        "discount": discount.toString(),
        "images": base64Images,
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
      throw Exception(error["message"] ?? "Failed to add new product");
    }
  }

  static Future<AddProdukModel> updateProduct({
    required int id,
    required String name,
    required String description,
    required int prices,
    required int stock,
    required int categoryId,
    required int brandId,
    required int discount,
    required List<File>? images,
  }) async {
    final url = Uri.parse("${Endpoint.products}/$id");
    final token = await PreferenceHandler.getToken();

    List<String> base64Images = [];
    if (images != null) {
      for (var img in images) {
        final bytes = await img.readAsBytes();
        final base64Str =
            "data:image/${img.path.split('.').last};base64,${base64Encode(bytes)}";
        base64Images.add(base64Str);
      }
    }

    final response = await http.put(
      url,
      body: jsonEncode({
        "name": name,
        "description": description,
        "price": prices.toString(),
        "stock": stock.toString(),
        "category_id": categoryId.toString(),
        "brand_id": brandId.toString(),
        "discount": discount.toString(),
        "images": base64Images,
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

  static Future<DeleteModel> deleteProduct({required int productId}) async {
    final url = Uri.parse("${Endpoint.products}/$productId");
    final token = await PreferenceHandler.getToken();

    final response = await http.delete(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return DeleteModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to delete product");
    }
  }

  //???????????????????????????????????
}
