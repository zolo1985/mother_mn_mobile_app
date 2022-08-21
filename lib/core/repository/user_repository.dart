abstract class UserRepository {
  Future<bool> isAuthorized();
  Future<String> getUserAccessToken();
  Future<void> updateAccessToken();
  Future<bool> checkTokenExpiry(String token);
  Future<String> getUserRefreshToken();
  Future<void> unauthorizeUser();
}