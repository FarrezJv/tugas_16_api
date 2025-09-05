import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tugas_16_api/API/endpoint/endpoint.dart';
import 'package:tugas_16_api/model/brand_user_model.dart';
import 'package:tugas_16_api/model/get_brand.dart';
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

  static Future<List<GetBrandData>> getBrand() async {
    final url = Uri.parse(Endpoint.getbrand);
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
      return userJson.map((json) => GetBrandData.fromJson(json)).toList();
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

  static Future<GetBrand> updateBrand({
    required String name,
    required int id,
    File? image,
  }) async {
    final url = Uri.parse("${Endpoint.brand}/$id");
    final token = await PreferenceHandler.getToken();
    final response = await http.put(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetBrand.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<GetBrand> deleteBrand({
    required String name,
    required int id,
  }) async {
    final url = Uri.parse("${Endpoint.brand}/$id");
    final token = await PreferenceHandler.getToken();
    final response = await http.delete(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetBrand.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<GetBrandData> postFotoBrand({
    required String name,
    required File image,
  }) async {
    final url = Uri.parse(Endpoint.brand);
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
      return GetBrandData.fromJson(json.decode(response.body)["data"]);
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }
}
