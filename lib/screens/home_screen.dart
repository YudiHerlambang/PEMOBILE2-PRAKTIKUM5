import 'package:flutter/material.dart';
import 'package:praktikum_5/components/banner_carousel.dart';
import 'package:praktikum_5/components/food_categories.dart';
import 'package:praktikum_5/components/recipes_grid.dart';
import 'package:praktikum_5/components/title_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Resep Makanan'.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.amber,
              ),
            ),
            const Text(
              'Masak Sendiri Kesukaanmu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        leading: const Icon(Icons.menu),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 18),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(child: BannerCarousel()),
          ),
          TitleSection(title: "Jenis Makanan", onPressed: () {}),
          const SliverToBoxAdapter(child: FoodCategories()),
          TitleSection(title: "Resep", onPressed: () {}),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: RecipesGrid(),
          ),
        ],
      ),
    );
  }
}
