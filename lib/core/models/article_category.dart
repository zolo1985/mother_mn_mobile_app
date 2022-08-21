class ArticleCategory {
  String? name;

  int? localId;
  int? articleForeignKey;

  ArticleCategory({this.localId, this.name, this.articleForeignKey});

  factory ArticleCategory.fromMap(Map<String, dynamic> json) {
    return ArticleCategory(
      localId: json["_id"] as int?,
      name: json["name"] as String?,
      articleForeignKey: json["article_foreign_key"] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "_id": localId,
      "name": name,
      "article_foreign_key": articleForeignKey,
    };

    return map;
  }
}