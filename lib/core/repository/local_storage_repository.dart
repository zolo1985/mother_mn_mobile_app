import '../models/article.dart';
import '../models/article_category.dart';
import '../models/article_image.dart';
import '../models/article_tag.dart';
import '../models/category.dart';
import '../models/tag.dart';
import '../models/user.dart';

abstract class LocalStorageRepository {
  //USER OPERATIONS
  Future<void> createUser({required User user});
  Future<void> updateUserAccessToken({required String token});
  Future<int?> fetchUserLocalId(String userId);
  Future<User> readUser(String userId);
  Future<void> deleteUsers();
  Future<bool> isAuthorized();
  Future<String> getUserAccessToken();
  Future<String> getUserRefreshToken();
  Future<void> unauthorizeUser();

  //ARTICLE OPERATIONS
  Future<bool> isArticleInDatabase(String articleId);
  Future<Article> fetchArticleFromDatabase(String articleId);
  Future<List<ArticleImage>> fetchArticleImagesFromDatabase({required int articleForeignKey});
  Future<int> saveArticleToDatabase({ required Article article });

  //CATEGORY OPERATIONS
  Future<void> saveCategoriesToDatabase(List<Category> categories);
  Future<bool> isCategoryInDatabase(String categoryId);

  //TAG OPERATIONS
  Future<void> saveTagsToDatabase(List<Tag> tags);
  Future<bool> isTagInDatabase(String tagId);

  Future<List<ArticleCategory>> fetchArticleCategoriesFromDatabase({required int articleForeignKey});
  Future<List<ArticleTag>> fetchArticleTagsFromDatabase({required int articleForeignKey});
}