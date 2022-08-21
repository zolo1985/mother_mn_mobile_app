import 'dart:convert';

import '../services/local_storage_repository_service.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../locator.dart';
import '../network/custom_exception.dart';
import '../services/remote_storage_repository_service.dart';

import 'base_view_model.dart';

class SignInScreenViewModel extends BaseViewModel {
  final LocalStorageRepositoryService _localService = locator<LocalStorageRepositoryService>();
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();
  String errorMsg = "";
  String email = "";
  String password = "";

  bool _isObscured=true;
  bool get isObscured => _isObscured;

  bool toggleIsObscured() {
    _isObscured = !_isObscured;
    notifyListeners();
    return _isObscured;
  }

  bool _isLoading=false;
  bool get isLoading => _isLoading;
  void _setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
  
  Future<bool> signIn() async {
    setState(ViewState.busy);
    try {
      _setIsLoading(true);
      final fetchedUser = await _remoteService.requestSignInAuth(base64.encode(utf8.encode('$email $password')));
      if (fetchedUser.user != null) {
        await _localService.createUser(user: fetchedUser.user!);
        _setIsLoading(false);
        return true;
      } else {
        _setIsLoading(false);
        setCustomException(CustomException(fetchedUser.msg!));
      }
    } on CustomException catch (e) {
      _setIsLoading(false);
      setCustomException(e);
    }
    setState(ViewState.idle);
    return false;
  }

  Future<void> launchURL(String urlString) async {
    final url = 'http://$urlString';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}