import 'package:flutter/material.dart';
import 'package:praktikum_5/configs/demo.dart';

class BannerModel {
  final String name;
  final String image;
  final String description;

  // Constructor
  BannerModel(this.name, this.image, this.description);

  // JSON converter
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(json['name'], json['image'], json['description']);
  }
}

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(banners[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
