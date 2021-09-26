import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';

class JsonService {

  static JsonService get instance => JsonService._initialize();
  final String _localJsonPath = "assets/json/categories.json";

  Future<List<CategoryModel>> loadCategorieJsonFromAssets() async {
    final String _categoryListAsString = await rootBundle.loadString(_localJsonPath);
    List<dynamic> decodedJson = json.decode(_categoryListAsString);
    final _categoryList = decodedJson.map((category) => CategoryModel.fromJson(category as Map<String, dynamic>)).toList();
    return _categoryList;
  }

  JsonService._initialize();
}
