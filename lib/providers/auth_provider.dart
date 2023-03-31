import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saleitnow/data/models/seller_model.dart';
import 'package:saleitnow/data/repos/auth_repo.dart';
import 'package:saleitnow/utils/shared_prefs.dart';
import 'package:saleitnow/utils/snack_bar.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final _prefs = SharedPrefs.instance();
  Future<bool> signIn(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await AuthRepo().signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      final data = response.data;
      log(data['token']);
      _prefs.setToken(data['token']);
      _prefs.setSellerId(data['id']);
      if (response.data['isApproved']) {
        log("Approved");
      }
      return true;
    } on DioError catch (e) {
      log(e.response.toString());
      dioError(context, e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logOut() async => _prefs.clear();

  signUp(SellerModelForRegistering seller, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      await AuthRepo().signUp(seller);
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Yay!'),
            content: Text('You have successfull'),
          ),
        );
      }
    } on DioError catch (e) {
      _isLoading = false;
      notifyListeners();
      dioError(context, e);
    }
  }
}
