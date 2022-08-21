class Comment {
  String? id;
  String? date;
  String? name;
  String? text;

  Comment({this.id, this.date, this.name, this.text});

  factory Comment.fromMap(Map<String, dynamic> json) {
    return Comment(  
      id: json['id'] as String?,
      date: json['date'] as String?,
      name: json['name'] as String?,
      text: json['text'] as String?,
    );
  }
}