import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tugas_16_api/API/endpoint/endpoint.dart';
import 'package:tugas_16_api/model/brand_user_model.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';

class BrandAPI {
  static Future<AddBrand> tambahBrand({required String name}) async {
    final url = Uri.parse(Endpoint.brand);
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      url,
      body: {"name": name},
      headers: {
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return AddBrand.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Tambah Brand gagal");
    }
  }

  static Future<List<AddBrandData>> getBrand() async {
    final url = Uri.parse(Endpoint.brand);
    final token = await PreferenceHandler.getToken();
    print(token);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        // "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body)["data"];
      print(response.body);
      return userJson.map((json) => AddBrandData.fromJson(json)).toList();
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  // static Future<AddBrand> loginUser({
  //   required String email,
  //   required String password,
  // }) async {
  //   final url = Uri.parse(Endpoint.login);
  //   final response = await http.post(
  //     url,
  //     body: {"email": email, "password": password},
  //     headers: {"Accept": "application/json"},
  //   );
  //   if (response.statusCode == 200) {
  //     return AddBrand.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Register gagal");
  //   }
  // }

  // static Future<GetBrand> updateBrand({required String name}) async {
  //   final url = Uri.parse(Endpoint.brand);
  //   final token = await PreferenceHandler.getToken();
  //   final response = await http.put(
  //     url,
  //     body: {"name": name},
  //     headers: {
  //       "Accept": "application/json",
  //       // "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return GetUserModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Register gagal");
  //   }
  // }
}
