import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:saleitnow/data/models/category_model.dart';
import 'package:saleitnow/data/models/product_model.dart';
import '../utils/pick_images.dart';
import '../utils/snack_bar.dart';
import '../data/repos/product_repo.dart';

class ProductProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final List<CategoryModel> _categoryList = [];
  List<CategoryModel> get categoryList => _categoryList;
  CategoryModel? _selectedCategory;
  CategoryModel? get selectedCategory => _selectedCategory;
  File? _thumbnail;
  File? get thumbnail => _thumbnail;
  final List<File> _pickedImages = [];
  List<File> get pickedImages => _pickedImages;

  void changeCategory(CategoryModel? categoryModel) {
    _selectedCategory = categoryModel;
    notifyListeners();
  }

  pickMultipleImages() async {
    final images = await pickImages();
    _pickedImages.addAll(images);
    notifyListeners();
  }

  getAllCategoryFromRepo(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await ProductRepo().getAllCategories();
      final data = response.data as Iterable;
      for (var element in data) {
        _categoryList.add(CategoryModel.fromJson(element));
      }
      _isLoading = false;
      notifyListeners();
    } on DioError catch (e) {
      _isLoading = false;
      notifyListeners();
      dioError(context, e);
    }
  }

  pickThumbnail() async {
    _thumbnail = await pickSingleImage();
    notifyListeners();
  }

  uploadProducts(
      {required String name,
      required String description,
      required double price,
      required int stock,
      required BuildContext context}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final product = ProductModel(
          name: name,
          description: description,
          category: _selectedCategory!.id,
          brand: 'brand',
          images: _pickedImages,
          thumbnail: _thumbnail!,
          price: price,
          countInStock: stock);
      log(product.toString());
      await ProductRepo().uploadProduct(product);
      _isLoading = false;
      notifyListeners();
    } on DioError catch (e) {
      _isLoading = false;
      notifyListeners();
      dioError(context, e);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      log(e.toString());
    }
  }
}