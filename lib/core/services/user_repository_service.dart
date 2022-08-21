import 'local_storage_repository_service.dart';
import 'remote_storage_repository_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../../locator.dart';
import '../repository/user_repository.dart';

class UserRepositoryService extends UserRepository {

  @override
  Future<bool> isAuthorized() async {
    final result = await locator<LocalStorageRepositoryService>().isAuthorized();
    return result;
  }
  
  @override
  Future<String> getUserAccessToken() async {
    final userAccessToken = await locator<LocalStorageRepositoryService>().getUserAccessToken();
    return userAccessToken;
  }

  @override
  Future<String> getUserRefreshToken() async {
    final userRefreshToken = await locator<LocalStorageRepositoryService>().getUserRefreshToken();
    return userRefreshToken;
  }
  
  @override
  Future<void> updateAccessToken() async {
    final userToken = await getUserAccessToken();

    if (await checkTokenExpiry(userToken)) {
      final newToken = await locator<RemoteStorageRepositoryService>().refreshToken();
      await locator<LocalStorageRepositoryService>().updateUserAccessToken(token: newToken.accessToken!);
    }
  }

  @override
  Future<bool> checkTokenExpiry(String token) async {
    final userToken = await getUserAccessToken();
    final DateTime? expiryDate = Jwt.getExpiryDate(userToken);
    final DateTime now = DateTime.now().toUtc();
    final isValid = now.isAfter(expiryDate!);
    return isValid;
  }

  @override
  Future<void> unauthorizeUser() async {
    await locator<LocalStorageRepositoryService>().unauthorizeUser();
  }
}