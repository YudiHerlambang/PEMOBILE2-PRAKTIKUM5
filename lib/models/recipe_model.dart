class RecipeModel {
  final int id;
  final String image;
  final String? name;
  final String? ingredients;
  final String? steps;

  RecipeModel({
    required this.id,
    required this.image,
    this.name,
    this.ingredients,
    this.steps,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      ingredients: json['ingredients'],
      steps: json['steps'],
    );
  }
}
