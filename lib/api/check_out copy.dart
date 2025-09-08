import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tugas_16_api/api/endpoint/endpoint.dart';
import 'package:tugas_16_api/model/Check_out/checkout.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';

class AuthenticationApiCheckOut {
  static Future<AddCheckOutModel> addCheckout({
    required int userId,
    required List<Item> items,
    required int total,
  }) async {
    final url = Uri.parse(Endpoint.checkout);
    final token = await PreferenceHandler.getToken();
    final response = await http.post(
      url,
      body: jsonEncode({
        "user_id": userId,
        "items": items.map((e) => e.toJson()).toList(),
        "total": total,
      }),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      return AddCheckOutModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Failed to checkout");
    }
  }

  // static Future<GetCartModel> getCart() async {
  //   final url = Uri.parse(Endpoint.cart);
  //   final token = await PreferenceHandler.getToken();
  //   final response = await http.get(
  //     url,
  //     headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  //   );
  //   if (response.statusCode == 200) {
  //     return GetCartModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Get data is not valid");
  //   }
  // }
}
