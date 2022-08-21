import '../../locator.dart';
import '../models/simple_response.dart';
import '../network/custom_exception.dart';
import '../services/remote_storage_repository_service.dart';
import 'base_view_model.dart';

class EmailChangeScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();
  String email = "";

  bool _isLoading=false;
  bool get isLoading => _isLoading;
  void _setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  Future<SimpleResponse> changeEmailToRemote() async {
    _setIsLoading(true);
    try {
      final response = await _remoteService.changeEmail(email.trim());
      _setIsLoading(false);
      return response;
    } on CustomException catch (e) {
      _setIsLoading(false);
      throw CustomException(e.msg);
    }
  }
}