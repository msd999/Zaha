class TipCard {
  String id;
  String tipId;
  String title;
  String image;
  String createdAt;

  TipCard({
    this.id,
    this.tipId,
    this.title,
    this.image,
    this.createdAt,
  });

  factory TipCard.fromJson(Map<String, dynamic> json) {
    return TipCard(
      id: json['id'] as String,
      tipId: json['cat_id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
