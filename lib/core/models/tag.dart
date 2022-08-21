class Tag {
  String? id;
  String? title;

  int? localId;
  int? articleForeignKey;

  Tag({this.id, this.title, this.localId, this.articleForeignKey});

  factory Tag.fromMap(Map<String, dynamic> json) {
    return Tag(
      localId: json['_id'] as int?,
      id: json['id'] as String?,
      title: json['title'] as String?,
      articleForeignKey: json["article_foreign_key"] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      '_id': localId,
      'id': id,
      'title': title,
      "article_foreign_key": articleForeignKey,
    };

    return map;
  }
}