class Token {
  String? accessToken;

  Token({this.accessToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'access_token': accessToken,
  };
}