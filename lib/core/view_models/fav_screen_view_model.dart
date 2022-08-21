import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../models/article.dart';
import '../../locator.dart';
import '../services/remote_storage_repository_service.dart';

import 'base_view_model.dart';

class FavScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();

  List<Article> _articles = [];
  List<Article> get articles => _articles;
  void _setArticles(List<Article> articles) {
    _articles = articles;
    notifyListeners();
  }

  Future<void> fetchArticlesFromRemote() async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      final articles = await _remoteService.fetchUserFavArticles();
      _setArticles(articles);
    } else {
      _setArticles(articles);
    }
    setState(ViewState.idle);
  }
}