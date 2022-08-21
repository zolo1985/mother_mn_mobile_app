import 'package:http_interceptor/http_interceptor.dart';


import '../../../../locator.dart';
import '../../services/user_repository_service.dart';

class RefreshTokenInterceptor implements InterceptorContract {
  final UserRepositoryService _userService = locator<UserRepositoryService>();
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final userToken = await _userService.getUserRefreshToken();

    data.headers["Authorization"] = "Bearer $userToken";
    data.headers["Content-Type"] = "application/json";

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}