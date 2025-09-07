import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tugas_16_api/api/endpoint/endpoint.dart';
import 'package:tugas_16_api/model/category/add_categories.dart';
import 'package:tugas_16_api/model/category/categories_model.dart';
import 'package:tugas_16_api/model/category/get_categories.dart';
import 'package:tugas_16_api/model/delete_model.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';

class AuthenticationApiCat {
  static Future<AddCategoriesModel> addCategories({
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.categories);
    final token = await PreferenceHandler.getToken();
    final response = await http.post(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return AddCategoriesModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to add new categories");
    }
  }

  static Future<GetCatModel> updateCategories({required String name}) async {
    final url = Uri.parse(Endpoint.categories);
    final token = await PreferenceHandler.getToken();
    final response = await http.put(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetCatModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Data is not valid");
    }
  }

  static Future<GetCatModel> getCategories() async {
    final url = Uri.parse(Endpoint.categories);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetCatModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Get data is not valid");
    }
  }

  static Future<DeleteModel> deleteCategory({
    required String name,
    required int id,
  }) async {
    final url = Uri.parse("${Endpoint.categories}/$id");
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
