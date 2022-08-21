import 'package:flutter/material.dart';
import '../network/custom_exception.dart';

enum ViewState { busy, idle }
enum DownloadingState {idle, starting, downloading, downloaded}
 
class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  CustomException? _customException;
  CustomException? get customException => _customException;

  void setCustomException(CustomException customException) {
    _customException = customException;
    notifyListeners();
  }

  DownloadingState _downloadingState = DownloadingState.idle;
  DownloadingState get downloadingState => _downloadingState;

  void setStateDownloadingState(DownloadingState downloadingState) {
    _downloadingState = downloadingState;
    notifyListeners();
  }
}