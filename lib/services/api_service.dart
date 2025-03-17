import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:praktikum_5/models/banner_model.dart';
import 'package:praktikum_5/models/category_model.dart';
import 'package:praktikum_5/models/recipe_model.dart';
import 'package:praktikum_5/models/review_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class ApiService {
  static const String API_URL = 'https://polindra.cicd.my.id/items/';
  static const String ASSET_URL = 'https://polindra.cicd.my.id/assets/';
  static const String UPLOAD_URL = 'https://polindra.cicd.my.id/files';
  static const String REVIEW_URL = 'https://polindra.cicd.my.id/items/fr_reviews';

  // Get Data (tidak ada perubahan)
  static Uri getUri(String collection) {
    return Uri.parse('$API_URL$collection');
  }

  static String getAsset(String id) {
    return '$ASSET_URL$id';
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
      throw Exception('Failed to load recipes');
    }
  }

  // Upload Gambar ke Server (perbaikan di sini)
  static Future<String> uploadImage(File imageFile) async {
    if (kIsWeb) {
      // Web
      final bytes = await imageFile.readAsBytes();
      final blob = html.Blob([bytes]);
      final formData = html.FormData();
      formData.appendBlob('file', blob, 'image.jpg');

      final request = http.Request('POST', Uri.parse(UPLOAD_URL));
      request.body = formData as String;

      final response = await request.send();
      if (response.statusCode == 200) {
        final res = jsonDecode(await response.stream.bytesToString());
        return res['data']['id'];
      } else {
        throw Exception('Gagal mengupload gambar (web)');
      }
    } else {
      // Native (Android, iOS)
      var request = http.MultipartRequest('POST', Uri.parse(UPLOAD_URL));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        final res = jsonDecode(await response.stream.bytesToString());
        return res['data']['id'];
      } else {
        throw Exception('Gagal mengupload gambar (native)');
      }
    }
  }

  // Kirim Review ke Server (tetap sama)
  static Future<bool> postReview(ReviewModel review) async {
    final response = await http.post(
      Uri.parse(REVIEW_URL),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(review.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Gagal mengirim review: ${response.body}');
    }
  }
}