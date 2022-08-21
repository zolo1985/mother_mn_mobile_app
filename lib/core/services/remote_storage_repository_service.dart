import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_http.dart';

import '../constants/constants.dart';
import '../models/article.dart';
import '../models/category.dart';
import '../models/comment.dart';
import '../models/search_result.dart';
import '../models/simple_response.dart';
import '../models/tag.dart';
import '../network/api/api_base_helper.dart';
import '../network/custom_exception.dart';

import '../models/publisher.dart';
import '../models/token.dart';
import '../models/user.dart';
import '../network/api_interceptor/refresh_token_interceptor.dart';
import '../repository/remote_storage_repository.dart';

class RemoteStorageRepositoryService extends RemoteStorageRepository {

  final ApiBaseHelper _apiHelper = ApiBaseHelper();

  @override
  Future<SimpleResponse> requestSignInAuth(String encryptedString) async {
    // var deviceData = <String, dynamic>{};
    // String identifier = "";

    // if (Platform.isAndroid) {
    //   deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    //   identifier = (await UniqueIdentifier.serial)!;
    // } 
    
    final header = {
      'Authorization': 'Basic $encryptedString',
      "Content-Type": "application/json"
    };

    try {
      final Uri url = Uri.parse('$baseUrl$signinApi');
      final response = await http.post(url, headers: header,
      body: json.encode(<String, String>{
        // "device_name": "${deviceData["brand"]} ${deviceData["model"]}",
        // "device_type": "android",
        // "device_unique_identifier": identifier,
      }));
      return SimpleResponse.fromJson(json.decode(response.body.toString()) as Map<String, dynamic>);
    } on SocketException {
      const msg = "Сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа!";
      throw CustomException(msg);
    }
  }


  @override
  Future<SimpleResponse> requestSignUpAuth({required String username, required String lastName, required String firstName, required String phone, required String email, required String password}) async {
    final header = {"Content-Type": "application/json"};
    try {
      final Uri url = Uri.parse('$baseUrl$signupApi');
      final response = await http.post(url, headers: header,
      body: json.encode(<String, String>{
        "username": username,
        "lastname": lastName,
        "firstname": firstName,
        "phone": phone,
        "email": email,
        "password": password,
      }));

      return SimpleResponse.fromJson(json.decode(response.body.toString()) as Map<String, dynamic>);

    } on SocketException {
      const msg = "Cүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа!";
      throw CustomException(msg);
    }
  }

  @override
  Future<SimpleResponse> requestSignOut() async {

    try {
      final response = await _apiHelper.post(signoutApi);
      return SimpleResponse.fromJson(json.decode(response.body.toString()) as Map<String, dynamic>);

    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }


  @override
  Future<Token> refreshToken() async {
    final http = InterceptedHttp.build(interceptors: [
        RefreshTokenInterceptor(),],
      );

    try {
      final Uri urlString = Uri.parse('$baseUrl$refreshAccesTokenApi');
      final response = await http.post(urlString);
      return Token.fromJson(jsonDecode(response.body.toString()) as Map<String, dynamic>);
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString().toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<User> fetchUserInfo() async {

    try {
      final response = await _apiHelper.post(userInfoApi);
      return User.fromMap(jsonDecode(response.body.toString()) as Map<String, dynamic>);
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<Article> fetchArticle(String articleId) async {
    try {
      final response = await _apiHelper.post(
        articleApi,
        body: json.encode(<String, String>{"article_id": articleId}),
      );
      return Article.fromMap(jsonDecode(response.body.toString()) as Map<String, dynamic>);
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Article>> fetchArticles() async {
    try {
      final response = await _apiHelper.post(articlesApi);
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Article.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Article>> fetchMoreArticles(String lastArticleId) async {
    try {
      final response = await _apiHelper.post(
        moreArticlesApi,
        body: json.encode(<String, String>{"article_id": lastArticleId}),
        );
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Article.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Article>> fetchMostReadArticles() async {
    try {
      final response = await _apiHelper.post(mostReadArticlesApi);
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Article.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Article>> fetchUserFavArticles() async {
    try {
      final response = await _apiHelper.post(userFavArticlesApi);
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Article.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Article>> fetchMostLikedArticles() async {
    try {
      final response = await _apiHelper.post(mostLikedArticlesApi);
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Article.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _apiHelper.post(categoriesApi);
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Category.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  //Search api
  @override
  Future<List<SearchResult>> search(String searchText) async {

    try {
      final response = await _apiHelper.post(
        searchApi,
        body: json.encode(<String, String>{
          "query": searchText,
        }),
      );
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => SearchResult.fromJson(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }
  
  @override
  Future<List<Article>> fetchCategoryArticles(String categoryId) async {
    try {
      final response = await _apiHelper.post(
        categoryArticlesApi,
        body: json.encode(<String, String>{
          "category_id": categoryId,
        }),
      );
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Article.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Article>> fetchMoreCategoryArticles({required String lastArticleId, required String categoryId}) async {
    try {
      final response = await _apiHelper.post(
        categoryMoreArticlesApi,
        body: json.encode(<String, String>{
          "article_id": lastArticleId,
          "category_id": categoryId,
          }),
        );
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Article.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Tag>> fetchTags() async {
    try {
      final response = await _apiHelper.post(tagsApi);
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Tag.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }
  
  @override
  Future<List<Article>> fetchTagArticles(String tagId) async {
    try {
      final response = await _apiHelper.post(
        tagArticlesApi,
        body: json.encode(<String, String>{
          "tag_id": tagId,
        }),
      );
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Article.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Article>> fetchMoreTagArticles({required String lastArticleId, required String tagId}) async {
    try {
      final response = await _apiHelper.post(
        tagMoreArticlesApi,
        body: json.encode(<String, String>{
          "article_id": lastArticleId,
          "tag_id": tagId,
          },
        ),
      );
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Article.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Publisher>> fetchPublishers() async {
    try {
      final response = await _apiHelper.post(publishersApi);
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Publisher.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Comment>> fetchArticleComments(String articleId) async {
    try {
      final response = await _apiHelper.post(
        articleCommentsApi, 
        body: json.encode(<String, String>{
          "article_id": articleId}));
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Comment.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<SimpleResponse> addArticleComment({required String articleId, required String text}) async {
    try {
      final response = await _apiHelper.post(
        addArticleCommentApi, 
        body: json.encode(<String, String>{
          "article_id": articleId,
          "text": text,}));
      return SimpleResponse.fromJson(jsonDecode(response.body.toString()) as Map<String, dynamic>);
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<List<Comment>> fetchArticleMoreComments({required String articleId, required String lastCommentId}) async {
    try {
      final response = await _apiHelper.post(
        articleMoreCommentsApi,
        body: json.encode(<String, String>{
          "article_id": articleId,
          "comment_id": lastCommentId,
          }),
        );
      final List responseJson = json.decode(response.body.toString()) as List<dynamic>;
      return responseJson.map((m) => Comment.fromMap(m as Map<String, dynamic>)).toList();
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<SimpleResponse> articleLike({required String articleId}) async {
    try {
      final response = await _apiHelper.post(
        articleLikeApi, 
        body: json.encode(<String, String>{
          "article_id": articleId}));
     
      return SimpleResponse.fromJson(jsonDecode(response.body.toString()) as Map<String, dynamic>);
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<SimpleResponse> changePassword({required String newPassword, required String currentPassword}) async {

    try {
      final response = await _apiHelper.post(
        changePasswordApi,
        body: json.encode(<String, String>{
          "password": newPassword,
          "current_password": currentPassword
        }),
      );
      return SimpleResponse.fromJson(jsonDecode(response.body.toString()) as Map<String, dynamic>);
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<SimpleResponse> changeEmail(String email) async {

    try {
      final response = await _apiHelper.post(
        changeEmailApi,
        body: json.encode(<String, String>{
          "email": email,
        }),
      );
      return SimpleResponse.fromJson(jsonDecode(response.body.toString()) as Map<String, dynamic>);
    } on SocketException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    } on BadRequestException catch (error) {
      final msg = json.decode(error.msg.toString());
      throw CustomException(msg["msg"].toString());
    } on UnauthorisedException {
      const msg = "Таньд зөвшөөрөл байхгүй байна!";
      throw CustomException(msg);
    } on FetchDataException {
      const msg = "Алдаа гарлаа эсвэл сүлжээгүй байна!";
      throw CustomException(msg);
    }
  }

  @override
  Future<void> sendArticleActivity(String articleId) async {
    await _apiHelper.post(
      articleActivityApi,
      body: json.encode(<String, String>{
        "article_id": articleId,
      }),
    );
  }
}