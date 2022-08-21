import '../../locator.dart';
import '../models/simple_response.dart';
import '../network/custom_exception.dart';
import '../services/remote_storage_repository_service.dart';
import 'base_view_model.dart';

class PasswordChangeScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();
  String currentPassword = "";
  String newPassword = "";

  bool _isLoading=false;
  bool get isLoading => _isLoading;
  void _setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  bool _isObscured=true;
  bool get isObscured => _isObscured;

  bool toggleIsObscured() {
    _isObscured = !_isObscured;
    notifyListeners();
    return _isObscured;
  }

  Future<SimpleResponse> changePasswordToRemote() async {
    _setIsLoading(true);
    try {
      final response = await _remoteService.changePassword(currentPassword: currentPassword, newPassword: newPassword);
      _setIsLoading(false);
      return response;
    } on CustomException catch (e) {
      _setIsLoading(false);
      throw CustomException(e.msg);
    }
  }
}