import 'package:flutter/material.dart';

import 'package:praktikum_5/models/recipe_model.dart';
import 'package:praktikum_5/services/api_service.dart';

class ItemCardRecipe extends StatelessWidget {
  final RecipeModel recipe;
  final Function(RecipeModel) onTap;

  const ItemCardRecipe({Key? key, required this.recipe, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(recipe),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 170,
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  ApiService.getAsset(recipe.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(recipe.name!),
        ],
      ),
    );
  }
}
