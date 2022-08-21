class User {
  String? id;
  String? username;
  String? accessToken;
  String? refreshToken;
  String? email;
  String? phone;
  

  //local props
  int? localId;
  int? isAuthenticated;

  User({this.localId, this.id, this.username, this.accessToken, this.refreshToken, this.email, this.phone, this.isAuthenticated});

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      localId: json['_id'] as int?,
      id: json["id"] as String?,
      username: json["username"] as String?,
      accessToken: json["access_token"] as String?,
      refreshToken: json["refresh_token"] as String?,
      email: json["email"] as String?,
      phone: json["phone"] as String?,
      isAuthenticated: json["is_authenticated"] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      "_id": localId,
      "id": id,
      "username": username,
      "access_token": accessToken,
      "refresh_token": refreshToken,
      "email": email,
      "phone": phone,
      "is_authenticated": isAuthenticated,
    };
    return map;
  }
}