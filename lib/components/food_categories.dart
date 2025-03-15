import 'package:flutter/material.dart';
import 'package:praktikum_5/models/category_model.dart';
import 'package:praktikum_5/services/api_service.dart';

class FoodCategories extends StatefulWidget {
  const FoodCategories({Key? key}) : super(key: key);

  @override
  _FoodCategoriesState createState() => _FoodCategoriesState();
}

class _FoodCategoriesState extends State<FoodCategories> {
  late Future<List<CategoryModel>> _futureCategories;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _futureCategories = ApiService.getCategories();
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 100, // Geser ke kiri 100px
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 100, // Geser ke kanan 100px
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: FutureBuilder<List<CategoryModel>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data'));
          } else {
            return Row(
              children: [
                // Tombol Geser Kiri
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _scrollLeft,
                ),

                // ListView Categories
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: index == 0
                            ? const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8)
                            : index == snapshot.data!.length - 1
                                ? const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 8)
                                : const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            ClipOval(
                              child: Image.network(
                                ApiService.getAsset(snapshot.data![index].image),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(snapshot.data![index].name ?? ''), // Menghindari error nullable
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Tombol Geser Kanan
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _scrollRight,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
