import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import '../../locator.dart';
import '../models/comment.dart';
import '../models/simple_response.dart';
import '../services/remote_storage_repository_service.dart';

import 'base_view_model.dart';

class CommentDetailScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();

  List<Comment> _comments = [];
  List<Comment> get comments => _comments;
  void _setComments(List<Comment> comments) {
    _comments = comments;
    notifyListeners();
  }

  Future<void> fetchArticleCommentsFromRemote(String articleId) async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      final comments = await _remoteService.fetchArticleComments(articleId);
      _setComments(comments);
    } else {
      _setComments(comments);
    }
    setState(ViewState.idle);
  }

  bool _hasReachedTheBottom = false;
  bool get hasReachedTheBottom => _hasReachedTheBottom;
  void _setHasReachedTheBottom(bool hasReachedTheBottom) {
    _hasReachedTheBottom = hasReachedTheBottom;
    notifyListeners();
  }

  Future<SimpleResponse> addArticleComment({required String articleId, required String text}) async {
    setState(ViewState.busy);
    final response = await _remoteService.addArticleComment(articleId: articleId, text: text);
    setState(ViewState.idle);
    return response;
  }

  Future<void> loadMoreArticleCommentsAndSet({ required String lastCommentId, required String articleId}) async {
    final moreCommentsFromRemote = await _remoteService.fetchArticleMoreComments(articleId: articleId, lastCommentId: lastCommentId);
    _comments.addAll(moreCommentsFromRemote);
    if (moreCommentsFromRemote.isEmpty) {
      _setHasReachedTheBottom(true);
    }
    notifyListeners();
  }

  String convertTime(String dateString) {
    var date = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString, true);
    var localTime = date.toLocal().toString();
    return localTime;
  }
}