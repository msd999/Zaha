class Specialization {
  String id;
  String name;
  String image;

  Specialization({
    this.id,
    this.name,
    this.image,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['cat_id'] as String,
      name: json['category'] as String,
      image: json['cat_img'] as String,
    );
  }
}
