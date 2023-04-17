import 'dart:developer' show log;
import 'package:dio/dio.dart';
import '../../utils/shared_prefs.dart';
import 'base_api.dart';

class SellerRepo {
  final api = BaseApi().dio;
  final token = SharedPrefs.instance().token;

  Future<Response> getSellerDetails() async {
    try {
      return await api.get(
        "/seller/my-profile",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Response> getAllOrders() async {
    try {
      return await api.get(
        "/seller/orders",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
