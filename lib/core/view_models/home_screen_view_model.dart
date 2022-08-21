import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mother_mobileapp/core/services/local_storage_repository_service.dart';
import '../models/article.dart';
import '../models/category.dart';
import '../../locator.dart';
import '../models/tag.dart';
import '../services/remote_storage_repository_service.dart';

import 'base_view_model.dart';

class HomeScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();
  final LocalStorageRepositoryService _localService = locator<LocalStorageRepositoryService>();

  List<Article> _articles = [];
  List<Article> get articles => _articles;
  void _setArticles(List<Article> articles) {
    _articles = articles;
    notifyListeners();
  }

  List<Article> _mostReadArticles = [];
  List<Article> get mostReadArticles => _mostReadArticles;
  void _setMostReadArticles(List<Article> mostReadArticles) {
    _mostReadArticles = mostReadArticles;
    notifyListeners();
  }

  List<Article> _mostLikedArticles = [];
  List<Article> get mostLikedArticles => _mostLikedArticles;
  void _setMostLikedArticles(List<Article> mostLikedArticles) {
    _mostLikedArticles = mostLikedArticles;
    notifyListeners();
  }

  List<Category> _categories = [];
  List<Category> get categories => _categories;
  void _setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  List<Tag> _tags = [];
  List<Tag> get tags => _tags;
  void _setTags(List<Tag> tags) {
    _tags = tags;
    notifyListeners();
  }

  Future<void> fetchArticlesFromRemote() async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      final articles = await _remoteService.fetchArticles();
      _setArticles(articles);
    } else {
      _setArticles(articles);
    }
    setState(ViewState.idle);
  }

  Future<void> fetchMostReadArticlesFromRemote() async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      final articles = await _remoteService.fetchMostReadArticles();
      _setMostReadArticles(articles.reversed.toList());
    } else {
      _setMostReadArticles(articles);
    }
    setState(ViewState.idle);
  }

  Future<void> fetchMostLikedArticlesFromRemote() async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      final articles = await _remoteService.fetchMostLikedArticles();
      _setMostLikedArticles(articles.reversed.toList());
    } else {
      _setMostLikedArticles(articles);
    }
    setState(ViewState.idle);
  }

  Future<void> fetchCategoriesFromRemote() async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      final categories = await _remoteService.fetchCategories();
      await _localService.saveCategoriesToDatabase(categories);
      _setCategories(categories);
    } else {
      _setCategories(categories);
    }
    setState(ViewState.idle);
  }

  Future<void> fetchTagsFromRemote() async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      final tags = await _remoteService.fetchTags();
      await _localService.saveTagsToDatabase(tags);
      _setTags(tags);
    } else {
      _setTags(tags);
    }
    setState(ViewState.idle);
  }
}