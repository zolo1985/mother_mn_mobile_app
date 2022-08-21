class Publisher {
  String? id;
  String? username;
  String? avatarId;
  String? bio;
  int? totalArticles;

  Publisher({this.id, this.username, this.avatarId, this.bio, this.totalArticles});

  factory Publisher.fromMap(Map<String, dynamic> json) {
    return Publisher(
      id: json['id'] as String?,
      username: json['username'] as String?,
      avatarId: json['avatar_id'] as String?,
      bio: json['bio'] as String?,
      totalArticles: json['total_articles'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'username': username,
      'avatar_id': avatarId,
      'bio': bio,
      'total_articles': totalArticles,
    };

    return map;
  }
}