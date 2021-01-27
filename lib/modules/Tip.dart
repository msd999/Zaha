class Tip {
  String id;
  String categoryId;
  String countryId;
  String title;
  String body;
  String image;
  String createdAt;

  Tip({
    this.id,
    this.categoryId,
    this.countryId,
    this.title,
    this.body,
    this.image,
    this.createdAt,
  });

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      id: json['id'] as String,
      categoryId: json['cat_id'] as String,
      countryId: json['country_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      image: json['image'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
