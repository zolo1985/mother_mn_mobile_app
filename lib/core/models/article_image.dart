class ArticleImage {
  String? imageUrl;

  int? localId;
  int? articleForeignKey;

  ArticleImage({this.localId, this.imageUrl, this.articleForeignKey});

  factory ArticleImage.fromMap(Map<String, dynamic> json) {
    return ArticleImage(
      localId: json["_id"] as int?,
      imageUrl: json["image_url"] as String?,
      articleForeignKey: json["article_foreign_key"] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "_id": localId,
      "image_url": imageUrl,
      "article_foreign_key": articleForeignKey,
    };

    return map;
  }
}