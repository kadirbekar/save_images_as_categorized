import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:save_images_as_categorized/core/constants/string_constants.dart';
import 'package:save_images_as_categorized/core/models/category_model.dart';

class LocalJsonDataService {

  static LocalJsonDataService? _instance;
  static LocalJsonDataService get instance => _instance ??= LocalJsonDataService._initialize();
  
  Future<List<CategoryModel>> loadCategorieJsonFromAssets() async {
    final String _categoryListAsString = await rootBundle.loadString(
      StringConstants.localCategoriesJsonFilePath,
    );
    List<dynamic> decodedJson = json.decode(
      _categoryListAsString,
    );
    final _categoryList = decodedJson
        .map(
          (category) => CategoryModel.fromJson(
            category as Map<String, dynamic>,
          ),
        )
        .toList();
    return _categoryList;
  }

  LocalJsonDataService._initialize();
}
