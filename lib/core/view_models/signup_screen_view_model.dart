import 'package:url_launcher/url_launcher_string.dart';
import '../../locator.dart';
import '../network/custom_exception.dart';
import '../services/remote_storage_repository_service.dart';

import 'base_view_model.dart';

class SignUpScreenViewModel extends BaseViewModel {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();
  DateTime? selectedDate;
  String username = "";
  String lastName = "";
  String firstName = "";
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

  Future<bool> signUpUserRequest() async {

    setState(ViewState.busy);

    try {
      _setIsLoading(true);
      final res = await _remoteService.requestSignUpAuth(
        username: username.trim(), 
        lastName: lastName.trim(), 
        firstName: firstName.trim(), 
        phone: "1234",
        email: email.trim(),
        password: password.trim());
      if (res.response == false) {
        _setIsLoading(false);
        setCustomException(CustomException(res.msg!));
      } else {
        setCustomException(CustomException(res.msg!));
        _setIsLoading(false);
        return true;
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