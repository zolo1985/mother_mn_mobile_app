import 'package:flutter/material.dart';
import 'package:mother_mobileapp/core/services/local_storage_repository_service.dart';
import 'package:share_plus/share_plus.dart';

import '../models/simple_response.dart';
import '../services/remote_storage_repository_service.dart';
import '../../locator.dart';
import '../models/article.dart';
import '../network/custom_exception.dart';
import 'base_view_model.dart';

enum LikeButtonNotifierState { loading, loaded }

class ArticleDetailScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();
  final LocalStorageRepositoryService _localService = locator<LocalStorageRepositoryService>();

  bool _isLiked = false;
  bool get isLiked => _isLiked;
  void _setIsLiked(bool isLiked) {
    _isLiked = isLiked;
    notifyListeners();
  }

  Article _article = Article(author: "", title: "", content: "", id: "", createdDate: "", images: []);
  Article get article => _article;
  void _setArticle(Article article) {
    _article = article;
    if (article.isLiked!) {
      _setIsLiked(true);
    } else {
      _setIsLiked(false);
    }
    notifyListeners();
  }

  bool toggleIsLiked() {
    _isLiked = !_isLiked;
    notifyListeners();
    return _isLiked;
  }

  Future<void> fetchArticleAndSet(String articleId) async {
    _remoteService.sendArticleActivity(articleId);
    setState(ViewState.busy);
    try {
      if (await _localService.isArticleInDatabase(articleId)) {
        final article = await _localService.fetchArticleFromDatabase(articleId);
        _setArticle(article);
      } else {
        final article = await _remoteService.fetchArticle(articleId);
        _localService.saveArticleToDatabase(article: article);
        _setArticle(article);
      }
    } on CustomException catch (e) {
      setCustomException(e);
    }
    setState(ViewState.idle);
  }

  LikeButtonNotifierState _likeButtonState = LikeButtonNotifierState.loaded;
  LikeButtonNotifierState get likeButtonState => _likeButtonState;
  void _setLikeButtonState(LikeButtonNotifierState likeButtonState) {
    _likeButtonState = likeButtonState;
    notifyListeners();
  }

  Future<SimpleResponse> likeOrUnlikeArticle({required String articleId}) async {
    _setLikeButtonState(LikeButtonNotifierState.loading);
    final response = await _remoteService.articleLike(articleId: articleId);
    // await updateLikeButtonToDatabase();
    _setLikeButtonState(LikeButtonNotifierState.loaded);
    return response;
  }

  Future<void> onShare(BuildContext context, String articleTitle) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share('"$articleTitle" нийтлэлийг Mother.mn-ээс уншаарай', sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}