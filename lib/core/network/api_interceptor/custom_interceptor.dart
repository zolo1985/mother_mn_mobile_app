import 'package:http_interceptor/http_interceptor.dart';

import '../../../locator.dart';
import '../../services/user_repository_service.dart';

class CustomInterceptor implements InterceptorContract {
  final UserRepositoryService _userService = locator<UserRepositoryService>();
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final userToken = await _userService.getUserAccessToken();
 
    data.headers["Authorization"] = "Bearer $userToken";
    data.headers["Content-Type"] = "application/json";
   
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  final UserRepositoryService _userService = locator<UserRepositoryService>();
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 401) {
      // Perform your token refresh here.
      await _userService.updateAccessToken();
      return true;
    }
    return false;
  }
}