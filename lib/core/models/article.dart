
import "article_image.dart";


class Article {
  String? id;
  String? title;
  String? author;
  String? content;
  String? createdDate;
  String? artwork;
  bool? isLiked;
  String? authorArtwork;
  List<ArticleImage>? images;
  List<dynamic>? categories;
  List<dynamic>? tags;

  //local props
  int? localId;
  

  Article({this.localId, this.id, this.title, this.author, this.content, this.createdDate, this.images, this.artwork, this.isLiked, this.authorArtwork, this.categories, this.tags});

  factory Article.fromMap(Map<String, dynamic> json) {
    return Article(
      localId: json["_id"] as int?,
      id: json["id"] as String?,
      title: json["title"] as String?,
      author: json["author"] as String?,
      content: json["content"] as String?,
      createdDate: json["created_date"] as String?,
      artwork: json["artwork"] as String?,
      isLiked: json["is_liked"]  == 1 ? true : false as bool?,
      authorArtwork: json["author_artwork"] as String?,
      images: json["images"] != null
        ? json["images"].map<ArticleImage>((json) => ArticleImage.fromMap(json as Map<String, dynamic>)).toList() as List<ArticleImage>
        : [],
      categories: json["categories"] != null
        ? json["categories"] as List<dynamic>
        : [],
      tags: json["tags"] != null
        ? json["tags"] as List<dynamic>
        : [],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "_id": localId,
      "id": id,
      "title": title,
      "author": author,
      "content": content,
      "created_date": createdDate,
      "artwork": artwork,
      "is_liked": isLiked,
      "author_artwork": authorArtwork,
    };
    return map;
  }
}