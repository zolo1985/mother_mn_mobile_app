import 'user.dart';

class SimpleResponse {
  bool? response;
  String? msg;
  User? user;

  SimpleResponse({this.msg, this.response, this.user});

  factory SimpleResponse.fromJson(Map<String, dynamic> json) {
    return SimpleResponse(
      response: json['response'] as bool?,
      msg: json['msg'] as String?,
      user: json['user'] != null ? User.fromMap(json['user'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'response': response,
        'msg': msg,
        'user': user,
      };
}