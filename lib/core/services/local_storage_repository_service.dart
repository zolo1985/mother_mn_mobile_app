import 'package:mother_mobileapp/core/models/article_category.dart';
import 'package:mother_mobileapp/core/models/article_image.dart';

import 'package:mother_mobileapp/core/models/article.dart';
import 'package:mother_mobileapp/core/models/tag.dart';
import 'package:mother_mobileapp/core/models/category.dart';

import '../models/article_tag.dart';
import '../repository/local_storage_repository.dart';

import '../database/mother_db.dart';
import '../models/user.dart';

class LocalStorageRepositoryService extends LocalStorageRepository {
  //USER OPERATIONS
  @override
  Future<void> createUser({required User user}) async {
    final db = MotherDB.instance;
    await db.createUser(user);
  }

  @override
  Future<void> updateUserAccessToken({required String token}) async {
    final db = MotherDB.instance;
    await db.updateUserAccessToken(token);
  }

  @override
  Future<int?> fetchUserLocalId(String userId) async {
    final db = MotherDB.instance;
    return await db.fetchUserLocalId(userId);
  }
  
  @override
  Future<User> readUser(String userId) async {
    final db = MotherDB.instance;
    return await db.readUser(userId);
  }

  @override
  Future<void> deleteUsers() async {
    final db = MotherDB.instance;
    await db.deleteAllUser();
  }

  @override
  Future<bool> isAuthorized() async {
    final db = MotherDB.instance;
    final result = await db.isUserAuthorized();
    return result;
  }

  @override
  Future<String> getUserAccessToken() async {
    final db = MotherDB.instance;
    final userAccessToken = await db.getUserToken();
    return userAccessToken;
  }

  @override
  Future<String> getUserRefreshToken() async {
    final db = MotherDB.instance;
    final userRefreshToken = await db.getUserRefreshToken();
    return userRefreshToken;
  }

  @override
  Future<void> unauthorizeUser() async {
    final db = MotherDB.instance;
    await db.deleteAllUser();
  }

  @override
  Future<Article> fetchArticleFromDatabase(String articleId) async {
    final db = MotherDB.instance;
    
    final article = await db.readArticle(articleId);
    article.images = await fetchArticleImagesFromDatabase(articleForeignKey: article.localId!);

    final categories = await fetchArticleCategoriesFromDatabase(articleForeignKey: article.localId!);
    article.categories = categories.map((item) => item.name as String).toList();

    final tags = await fetchArticleTagsFromDatabase(articleForeignKey: article.localId!);
    article.tags = tags.map((item) => item.title as String).toList();
    return article;
  }

  @override
  Future<List<ArticleImage>> fetchArticleImagesFromDatabase({required int articleForeignKey}) async {
    final db = MotherDB.instance;
    final articleImages = await db.fetchArticleImages(articleForeignKey: articleForeignKey);
    return articleImages;
  }

  @override
  Future<List<ArticleCategory>> fetchArticleCategoriesFromDatabase({required int articleForeignKey}) async {
    final db = MotherDB.instance;
    final articleCategories = await db.fetchArticleCategories(articleForeignKey: articleForeignKey);
    return articleCategories;
  }

  @override
  Future<List<ArticleTag>> fetchArticleTagsFromDatabase({required int articleForeignKey}) async {
    final db = MotherDB.instance;
    final articleTags = await db.fetchArticleTags(articleForeignKey: articleForeignKey);
    return articleTags;
  }

  @override
  Future<bool> isArticleInDatabase(String articleId) async {
    final db = MotherDB.instance;
    final value = await db.isArticleInDatabase(articleId);
    return value;
  }

  @override
  Future<int> saveArticleToDatabase({required Article article}) async {
    final db = MotherDB.instance;
    final articleId = await db.createArticle(article);
    return articleId!;
  }

  @override
  Future<void> saveCategoriesToDatabase(List<Category> categories) async {
    final db = MotherDB.instance;
    for (var i = 0; i < categories.length; i++) {
        if (await isTagInDatabase(categories[i].id!)) {

        } else {
          await db.createCategory(categories[i]);
        }
    }
  }

  @override
  Future<void> saveTagsToDatabase(List<Tag> tags) async {
    final db = MotherDB.instance;
    for (var i = 0; i < tags.length; i++) {
        if (await isTagInDatabase(tags[i].id!)) {

        } else {
          await db.createTag(tags[i]);
        }
    }
  }

  @override
  Future<bool> isTagInDatabase(String tagId) async {
    final db = MotherDB.instance;
    final value = await db.isTagInDatabase(tagId);
    return value;
  }

  @override
  Future<bool> isCategoryInDatabase(String categoryId) async {
    final db = MotherDB.instance;
    final value = await db.isCategoryInDatabase(categoryId);
    return value;
  }
}