import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tugas_16_api/api/endpoint/endpoint.dart';
import 'package:tugas_16_api/model/history/history.dart';
import 'package:tugas_16_api/shared_preference/shared.dart';

class AuthenticationApiHistory {
  // static Future<AddCartModel> addCart({
  //   required int productId,
  //   required int quantity,
  // }) async {
  //   final url = Uri.parse(Endpoint.cart);
  //   final token = await PreferenceHandler.getToken();
  //   final response = await http.post(
  //     url,
  //     body: jsonEncode({"product_id": productId, "quantity": quantity}),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return AddCartModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Failed to add new cart");
  //   }
  // }

  static Future<GetHistoryModel> getHistory() async {
    final url = Uri.parse(Endpoint.history);
    final token = await PreferenceHandler.getToken();
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return GetHistoryModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Get data is not valid");
    }
  }

  // static Future<DeleteModel> deleteCart({required int CartId}) async {
  //   final url = Uri.parse("${Endpoint.cart}/$CartId");
  //   final token = await PreferenceHandler.getToken();

  //   final response = await http.delete(
  //     url,
  //     headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  //   );

  //   if (response.statusCode == 200) {
  //     return DeleteModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Failed to delete cart");
  //   }
  // }
}
