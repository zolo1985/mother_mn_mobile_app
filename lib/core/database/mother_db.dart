// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/article.dart';
import '../models/article_category.dart';
import '../models/article_image.dart';
import '../models/article_tag.dart';
import '../models/category.dart';
import '../models/tag.dart';
import '../models/user.dart';
import '../network/custom_exception.dart';

class MotherDB {
  static final MotherDB instance = MotherDB._init();

  static Database? _database;

  MotherDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('alkjsdkljlkvjlkasdklajlkda.db');

    return _database!;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path,
        version: 1, onCreate: _createDB, onConfigure: _onConfigure);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE user (
  _id                         INTEGER PRIMARY KEY AUTOINCREMENT,
  id                          TEXT,
  username                    TEXT,
  access_token                TEXT,
  refresh_token               TEXT,
  email                       TEXT,
  phone                       TEXT,
  is_authenticated            TINYINT DEFAULT 0
  )
''');

    await db.execute('''
CREATE TABLE article (
  _id                                      INTEGER PRIMARY KEY AUTOINCREMENT,
  id                                       TEXT,
  title                                    TEXT,
  author                                   TEXT,
  content                                  TEXT,
  created_date                             TEXT,
  artwork                                  TEXT,
  author_artwork                           TEXT,
  categories                               TEXT,
  tags                                     TEXT,
  is_liked                                 TINYINT DEFAULT 0
  )
''');

    await db.execute('''
CREATE TABLE article_image (
  _id                                   INTEGER PRIMARY KEY AUTOINCREMENT,
  image_url                             TEXT,
  article_foreign_key                   INTEGER,
  FOREIGN KEY(article_foreign_key) REFERENCES article(_id)
  )
''');

    await db.execute('''
CREATE TABLE article_category (
  _id                                   INTEGER PRIMARY KEY AUTOINCREMENT,
  name                                  TEXT,
  article_foreign_key                   INTEGER,
  FOREIGN KEY(article_foreign_key) REFERENCES article(_id)
  )
''');

    await db.execute('''
CREATE TABLE article_tag (
  _id                                   INTEGER PRIMARY KEY AUTOINCREMENT,
  title                                  TEXT,
  article_foreign_key                   INTEGER,
  FOREIGN KEY(article_foreign_key) REFERENCES article(_id)
  )
''');

    await db.execute('''
CREATE TABLE category (
  _id                                   INTEGER PRIMARY KEY AUTOINCREMENT,
  id                                    TEXT,
  name                                  TEXT,
  article_foreign_key                   INTEGER,
  FOREIGN KEY(article_foreign_key) REFERENCES article(_id)
  )
''');

    await db.execute('''
CREATE TABLE tag (
  _id                                   INTEGER PRIMARY KEY AUTOINCREMENT,
  id                                    TEXT,
  title                                 TEXT,
  article_foreign_key                   INTEGER,
  FOREIGN KEY(article_foreign_key) REFERENCES article(_id)
  )
''');
}


  //USER OPERATIONS
  Future<int?> createUser(User user) async {
    final db = await instance.database;
    final result = await db.query('user', where: "id = ?", whereArgs: [user.id]);

    if (result.isNotEmpty) {
      return result.first["_id"] as int?;
    } else {
      final userToAdd = User(
        id: user.id,
        username: user.username,
        accessToken: user.accessToken,
        refreshToken: user.refreshToken,
        email: user.email,
        phone: user.phone,
        isAuthenticated: 1,
      );
      final res = await db.insert(
        'user',
        userToAdd.toMap());
      return res;
    }
  }

  Future<User> readUser(String userId) async {
    final db = await instance.database;
    final result = await db.query('user', where: "id = ?", whereArgs: [userId], limit: 1);
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      throw CustomException("Хэрэглэгч олдсонгүй");
    }
  }

  Future<void> updateUserAccessToken(String token) async {
    final db = await instance.database;
    await db.rawUpdate('UPDATE user SET access_token = ?', [token]);
  }

  Future<int?> fetchUserLocalId(String userId) async {
    final db = await instance.database;
    final result = await db.query('user', where: "id = ?", whereArgs: [userId]);

    if (result.isNotEmpty) {
      return result.first["_id"] as int?;
    } else {
      throw CustomException("Хэрэглэгч олдсонгүй");
    }
  }

  Future<bool> isUserAuthorized() async {
    final db = await instance.database;
    final result = await db.rawQuery("SELECT * FROM user limit 1");
    if (result.isEmpty) {
      return false;
    } else {
      if (result.first["is_authenticated"] == 1) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<String> getUserToken() async {
    final db = await instance.database;
    final result = await db.rawQuery("SELECT access_token FROM user limit 1");
    if (result.isNotEmpty) {
      return result.first["access_token"].toString();
    } else {
      throw CustomException("Хэрэглэгч олдсонгүй");
    }
  }

  Future<String> getUserRefreshToken() async {
    final db = await instance.database;
    final result = await db.rawQuery("SELECT refresh_token FROM user limit 1");
    if (result.isNotEmpty) {
      return result.first["refresh_token"].toString();
    } else {
      throw CustomException("Хэрэглэгч олдсонгүй");
    }
  }

  Future<void> deleteAllUser() async {
    final db = await instance.database;
    await db.rawDelete('delete from user');
  }

  //ARTICLE OPERATIONS
  Future<int?> createArticle(Article article) async {
    final db = await instance.database;
    final result = await db.query('article', where: "id = ?", whereArgs: [article.id], limit: 1);
    if (result.isNotEmpty) {
      return result.first["_id"] as int?;
    } else {
      final res = await db.insert('article', article.toMap());

    if (article.images!.isNotEmpty) {
      final images = article.images;
      for (int i = 0; i < images!.length; i++) {
        await createArticleImage(images[i], res);
      }
    }

    if (article.categories!.isNotEmpty) {
      final categories = article.categories;
      for (int i = 0; i < categories!.length; i++) {
        await createArticleCategory(categories[i], res);
      }
    }

    if (article.tags!.isNotEmpty) {
      final tags = article.tags;
      for (int i = 0; i < tags!.length; i++) {
        await createArticleTag(tags[i], res);
      }
    }

    return res;
    }
  }

  Future<List<ArticleImage>> fetchArticleImages({required int articleForeignKey}) async {
    final db = await instance.database;
    final result = await db.query('article_image', where: "article_foreign_key = ?", whereArgs: [articleForeignKey]);

    if (result.isNotEmpty) {
      return result.map((json) => ArticleImage.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<ArticleCategory>> fetchArticleCategories({required int articleForeignKey}) async {
    final db = await instance.database;
    final result = await db.query('article_category', where: "article_foreign_key = ?", whereArgs: [articleForeignKey]);

    if (result.isNotEmpty) {
      return result.map((json) => ArticleCategory.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<ArticleTag>> fetchArticleTags({required int articleForeignKey}) async {
    final db = await instance.database;
    final result = await db.query('article_tag', where: "article_foreign_key = ?", whereArgs: [articleForeignKey]);

    if (result.isNotEmpty) {
      return result.map((json) => ArticleTag.fromMap(json)).toList();
    } else {
      return [];
    }
  }

  Future<int?> createArticleImage(ArticleImage image, int articleForeignKey) async {
    final db = await instance.database;
    final itemToAdd = ArticleImage(
      imageUrl: image.imageUrl,
      articleForeignKey: articleForeignKey,);
    final res = await db.insert('article_image', itemToAdd.toMap());
    return res;
  }

  Future<int?> createArticleCategory(String categoryName, int articleForeignKey) async {
    final db = await instance.database;
    final itemToAdd = ArticleCategory(
      name: categoryName,
      articleForeignKey: articleForeignKey,);
    final res = await db.insert('article_category', itemToAdd.toMap());
    return res;
  }

  Future<int?> createArticleTag(String tagTitle, int articleForeignKey) async {
    final db = await instance.database;
    final itemToAdd = ArticleTag(
      title: tagTitle,
      articleForeignKey: articleForeignKey,);
    final res = await db.insert('article_tag', itemToAdd.toMap());
    return res;
  }

  Future<Article> readArticle(String articleId) async {
    final db = await instance.database;
    final result = await db.query('article', where: "id = ?", whereArgs: [articleId], limit: 1);
    if (result.isNotEmpty) {
      return Article.fromMap(result.first);
    } else {
      throw CustomException("Нийтлэл олдсонгүй");
    }
  }

  Future<bool> isArticleInDatabase(String articleId) async {
    final db = await instance.database;
    final result = await db.query('article', where: "id = ?", whereArgs: [articleId], limit: 1);
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<int?> createCategory(Category category) async {
    final db = await instance.database;
    final itemToAdd = Category(
      id: category.id,
      name: category.name);
    final res = await db.insert('category', itemToAdd.toMap());
    return res;
  }

  Future<Category> readCategory(String categoryName) async {
    final db = await instance.database;
    final result = await db.query('category', where: "name = ?", whereArgs: [categoryName], limit: 1);
    if (result.isNotEmpty) {
      return Category.fromMap(result.first);
    } else {
      throw CustomException("Ангилал олдсонгүй");
    }
  }

  Future<bool> isCategoryInDatabase(String categoryId) async {
    final db = await instance.database;
    final result = await db.query('category', where: "id = ?", whereArgs: [categoryId], limit: 1);
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<int?> createTag(Tag tag) async {
    final db = await instance.database;
    final itemToAdd = Tag(
      id: tag.id,
      title: tag.title);
    final res = await db.insert('tag', itemToAdd.toMap());
    return res;
  }

  Future<Tag> readTag(String tagTitle) async {
    final db = await instance.database;
    final result = await db.query('tag', where: "title = ?", whereArgs: [tagTitle], limit: 1);
    if (result.isNotEmpty) {
      return Tag.fromMap(result.first);
    } else {
      throw CustomException("Түлхүүр үг олдсонгүй");
    }
  }

  Future<bool> isTagInDatabase(String tagId) async {
    final db = await instance.database;
    final result = await db.query('tag', where: "id = ?", whereArgs: [tagId], limit: 1);
    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
