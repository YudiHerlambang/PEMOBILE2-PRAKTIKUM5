class BannerModel {
  final String name;
  final String image;
  final String description;

  // make constructor
  BannerModel(this.name, this.image, this.description);

  // json converter
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(json['name'], json['image'], json['description']);
  }
}
