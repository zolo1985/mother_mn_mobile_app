import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_http.dart';
import '../api_interceptor/custom_interceptor.dart';

import '../../constants/constants.dart';
import '../custom_exception.dart';

class ApiBaseHelper {

  Future<dynamic> post(String url, {Map<String, String>? header, Object? body}) async {
    
    final http = InterceptedHttp.build(interceptors: [
      CustomInterceptor(),],
      retryPolicy: ExpiredTokenRetryPolicy(),
    );
    
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    final Uri urlString = Uri.parse('$baseUrl$url');
    try {
      final response = await http.post(urlString, headers: header, body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('Сүлжээгүй эсвэл алдаа гарлаа!');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Сүлжээгүй эсвэл алдаа гарлаа!');
    }
  }
}