import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tugas_16_api/api/endpoint/endpoint.dart';
import 'package:tugas_16_api/model/products/delete_model.dart';
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

    var request = http.MultipartRequest("POST", url);

    for (var img in images) {
      request.files.add(
        await http.MultipartFile.fromPath("images[]", img.path),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return AddProdukModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to add new product");
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
}
