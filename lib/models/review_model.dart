class ReviewModel {
  final int recipesId;
  final String name;
  final String description;
  final String ratting; // Perbaiki nama bidang
  final String? image;
  final String? userCreated; // Tambahkan user_created (opsional)

  ReviewModel({
    required this.recipesId,
    required this.name,
    required this.description,
    required this.ratting, // Perbaiki nama bidang
    this.image,
    this.userCreated, // Tambahkan user_created (opsional)
  });

  Map<String, dynamic> toJson() {
    return {
      'recipes_id': recipesId,
      'name': name,
      'description': description,
      'ratting': ratting, // Perbaiki nama bidang
      'image': image,
      'user_created': userCreated, // Tambahkan user_created (opsional)
    };
  }
}