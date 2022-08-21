class SearchResult {

  String? id;
  String? title;
  String? artwork;

  SearchResult({this.id, this.title, this.artwork});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(  
      id: json['id'] as String?,
      title: json['title'] as String?,
      artwork: json['artwork'] as String?,
    );
  }
}