import '../models/article.dart';
import '../models/category.dart';
import '../models/simple_response.dart';

import '../models/comment.dart';
import '../models/publisher.dart';
import '../models/search_result.dart';
import '../models/tag.dart';
import '../models/token.dart';
import '../models/user.dart';

abstract class RemoteStorageRepository {
  //ARTICLES OPERATIONS
  Future<List<Article>> fetchArticles();
  Future<List<Article>> fetchMoreArticles(String lastArticleId);
  Future<List<Article>> fetchMostReadArticles();
  Future<List<Article>> fetchUserFavArticles();
  Future<List<Article>> fetchMostLikedArticles();
  Future<List<Category>> fetchCategories();
  Future<List<Article>> fetchCategoryArticles(String categoryId);
  Future<List<Article>> fetchMoreCategoryArticles({required String lastArticleId, required String categoryId});
  Future<List<Tag>> fetchTags();
  Future<List<Article>> fetchTagArticles(String tagId);
  Future<List<Article>> fetchMoreTagArticles({required String lastArticleId, required String tagId});
  Future<List<Publisher>> fetchPublishers();
  Future<Article> fetchArticle(String articleId);
  Future<List<Comment>> fetchArticleComments(String articleId);
  Future<SimpleResponse> addArticleComment({required String articleId, required String text});
  Future<List<Comment>> fetchArticleMoreComments({required String articleId, required String lastCommentId});
  Future<SimpleResponse> articleLike({required String articleId});

  //SEARCH OPERATIONS
  Future<List<SearchResult>> search(String searchText);

  //AUTH
  Future<SimpleResponse> requestSignInAuth(String encryptedString);
  Future<SimpleResponse> requestSignUpAuth({
    required String username, 
    required String lastName,
    required String firstName,
    required String phone,
    required String email,
    required String password,
  });
  Future<Token> refreshToken();
  Future<SimpleResponse> requestSignOut();
  Future<User> fetchUserInfo();

  Future<SimpleResponse> changePassword({required String newPassword, required String currentPassword});
  Future<SimpleResponse> changeEmail(String email);
  Future<void> sendArticleActivity(String articleId);
}