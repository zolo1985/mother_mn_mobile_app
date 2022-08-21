import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../services/user_repository_service.dart';

import '../../locator.dart';
import '../models/user.dart';
import '../network/custom_exception.dart';
import '../services/remote_storage_repository_service.dart';

import 'base_view_model.dart';

class AccountSettingsScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();
  final UserRepositoryService _userService = locator<UserRepositoryService>();

  User _user = User(id:"", username: "", email: "", phone: "");
  User get user => _user;
  void _setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> fetchInfoAndSet() async {
    try {
      final info = await _remoteService.fetchUserInfo();
      _setUser(info);
    } on CustomException catch (e) {
      setCustomException(e);
    }
  }

  Future<void> signOutUser() async {
    setState(ViewState.busy);
    if (await InternetConnectionChecker().hasConnection) {
      try {
        final response = await _remoteService.requestSignOut();

        if (response.response!) {
          await _userService.unauthorizeUser();
        }
      } on CustomException catch (e) {
        setCustomException(e);
      }
    } else {
      await _userService.unauthorizeUser();
    }
    setState(ViewState.idle);
  }
}