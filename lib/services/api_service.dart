import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:praktikum_5/models/banner_model.dart';
import 'package:praktikum_5/models/category_model.dart';
import 'package:praktikum_5/models/recipe_model.dart';

class ApiService {
  static var API_URL = 'https://polindra.cicd.my.id/items/';
  static var ASSET_URL = 'https://polindra.cicd.my.id/assets/';

  static Uri getUri(String collection) {
    return Uri.parse('${API_URL}${collection}');
  }

  static String getAsset(String id) {
    return '${ASSET_URL}${id}';
  }

  static Future<List<BannerModel>> getBanners() async {
    final response = await http.get(
      getUri('fr_banners?filter[status][_eq]=published'),
    );

    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => BannerModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load banners');
    }
  }

  static Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
      getUri('fr_categories?filter[status][_eq]=published'),
    );

    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => CategoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<RecipeModel>> getRecipes() async {
    final response = await http.get(
      getUri('fr_recipes?filter[status][_eq]=published'),
    );

    if (response.statusCode == 200) {
      final dynamic body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((item) => RecipeModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
