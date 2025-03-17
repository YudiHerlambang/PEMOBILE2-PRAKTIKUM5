class ReviewModel {
  final int recipesId;
  final String name;
  final String description;
  final String ratting;
  final String? image;
  final String? userCreated;
  final String? status;

  ReviewModel({
    required this.recipesId,
    required this.name,
    required this.description,
    required this.ratting,
    this.image,
    this.userCreated,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipes_id': recipesId,
      'name': name,
      'description': description,
      'ratting': ratting,
      'image': image,
      'user_created': userCreated,
      'status': status,
    };
  }
}