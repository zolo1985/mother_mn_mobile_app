import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../models/article.dart';
import '../../locator.dart';
import '../services/remote_storage_repository_service.dart';

import 'base_view_model.dart';

class TagArticlesScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();

  List<Article> _articles = [];
  List<Article> get articles => _articles;
  void _setArticles(List<Article> articles) {
    _articles = articles;
    notifyListeners();
  }

  bool _hasReachedTheBottom = false;
  bool get hasReachedTheBottom => _hasReachedTheBottom;
  void _setHasReachedTheBottom(bool hasReachedTheBottom) {
    _hasReachedTheBottom = hasReachedTheBottom;
    notifyListeners();
  }

  Future<void> fetchArticlesFromRemote(String tagId) async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      final articles = await _remoteService.fetchTagArticles(tagId);
      _setArticles(articles);
    } else {
      _setArticles(articles);
    }
    setState(ViewState.idle);
  }

  Future<void> loadMoreArticlesAndSet({ required String lastArticleId, required String tagId}) async {
    final articlesFromRemote = await _remoteService.fetchMoreTagArticles(lastArticleId: lastArticleId, tagId: tagId);
    _articles.addAll(articlesFromRemote);
    if (articlesFromRemote.isEmpty) {
      _setHasReachedTheBottom(true);
    } else {
      _setHasReachedTheBottom(false);
    }
    notifyListeners();
  }
}