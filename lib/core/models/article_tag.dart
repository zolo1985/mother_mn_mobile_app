class ArticleTag {
  String? title;

  int? localId;
  int? articleForeignKey;

  ArticleTag({this.localId, this.title, this.articleForeignKey});

  factory ArticleTag.fromMap(Map<String, dynamic> json) {
    return ArticleTag(
      localId: json["_id"] as int?,
      title: json["title"] as String?,
      articleForeignKey: json["article_foreign_key"] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "_id": localId,
      "title": title,
      "article_foreign_key": articleForeignKey,
    };

    return map;
  }
}