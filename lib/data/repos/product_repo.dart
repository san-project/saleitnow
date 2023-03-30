import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:saleitnow/data/repos/base_api.dart';

import '../../utils/shared_prefs.dart';
import '../models/product_model.dart';

class ProductRepo {
  final api = BaseApi().dio;
  final token = SharedPrefs.instance().token;

  Future<Response> uploadProduct(ProductModel product) async {
    try {
      final data = await product.toJson();
      log(data.toString());
      return api.post('/product',
          data: data,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Response> getAllCategories() async {
    try {
      return api.get('/category');
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}