import 'package:flutter/material.dart';
import 'package:praktikum_5/components/item_card_recipe.dart';
import 'package:praktikum_5/models/recipe_model.dart';
import 'package:praktikum_5/screens/recipe_detail_screen.dart';
import 'package:praktikum_5/services/api_service.dart';

class RecipesGrid extends StatefulWidget {
  const RecipesGrid({Key? key}) : super(key: key);

  @override
  _RecipesGridState createState() => _RecipesGridState();
}

class _RecipesGridState extends State<RecipesGrid> {
  late Future<List<RecipeModel>> _futureRecipes;

  @override
  void initState() {
    super.initState();
    _futureRecipes = ApiService.getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RecipeModel>>(
      future: _futureRecipes,
      builder: (context, snapshot) {
        return _buildRecipeView(context, snapshot);
      },
    );
  }

  Widget _buildRecipeView(BuildContext context, AsyncSnapshot<List<RecipeModel>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (snapshot.hasError) {
      return SliverToBoxAdapter(
        child: Center(child: Text('Error: ${snapshot.error}')),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(child: Text('No data')),
      );
    } else {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 2, // Perubahan di sini
          childAspectRatio: 1.4,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ItemCardRecipe(
              recipe: snapshot.data![index],
              onTap: (RecipeModel recipe) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
            );
          },
          childCount: snapshot.data!.length,
        ),
      );
    }
  }
}