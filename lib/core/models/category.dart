class Category {
  String? id;
  String? name;

  int? localId;
  int? articleForeignKey;

  Category({this.id, this.name, this.localId, this.articleForeignKey});

  factory Category.fromMap(Map<String, dynamic> json) {
    return Category(
      localId: json['_id'] as int?,
      id: json['id'] as String?,
      name: json['name'] as String?,
      articleForeignKey: json["article_foreign_key"] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      '_id': localId,
      'id': id,
      'name': name,
      "article_foreign_key": articleForeignKey,
    };

    return map;
  }
}