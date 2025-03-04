import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:praktikum_5/models/banner_model.dart';

class ApiService {
  static Future<List<BannerModel>> getBanners() async {
    try {
      final response = await http.get(
        Uri.parse('https://cms.cicd.my.id/items/fr_banners'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => BannerModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load banners: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching banners: $e');
    }
  }
}
