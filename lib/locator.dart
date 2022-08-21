import 'package:get_it/get_it.dart';
import 'core/services/local_storage_repository_service.dart';
import 'core/services/remote_storage_repository_service.dart';
import 'core/view_models/account_settings_screen_view_model.dart';

import 'core/services/user_repository_service.dart';
import 'core/view_models/article_detail_screen_view_model.dart';
import 'core/view_models/category_articles_screen_view_model.dart';
import 'core/view_models/comment_detail_screen_view_model.dart';
import 'core/view_models/email_change_screen_view_model.dart';
import 'core/view_models/home_screen_view_model.dart';
import 'core/view_models/password_change_screen_view_model.dart';
import 'core/view_models/publishers_screen_model.dart';
import 'core/view_models/search_screen_view_model.dart';
import 'core/view_models/signin_screen_view_model.dart';
import 'core/view_models/signup_screen_view_model.dart';
import 'core/view_models/tag_articles_view_model.dart';

GetIt locator = GetIt.I;

Future<void> setupServiceLocator() async {
  locator.registerSingleton<UserRepositoryService>(UserRepositoryService());
  locator.registerLazySingleton<LocalStorageRepositoryService>(() => LocalStorageRepositoryService());
  locator.registerLazySingleton<RemoteStorageRepositoryService>(() => RemoteStorageRepositoryService());
  
  locator.registerFactory(() => HomeScreenViewModel());
  locator.registerFactory(() => SearchScreenViewModel());
  locator.registerFactory(() => CategoryArticlesScreenViewModel());
  locator.registerFactory(() => TagArticlesScreenViewModel());
  locator.registerFactory(() => PublishersScreenViewModel());
  locator.registerFactory(() => ArticleDetailScreenViewModel());
  locator.registerFactory(() => CommentDetailScreenViewModel());
  locator.registerFactory(() => SignInScreenViewModel());
  locator.registerFactory(() => SignUpScreenViewModel());
  locator.registerFactory(() => AccountSettingsScreenViewModel());
  locator.registerFactory(() => PasswordChangeScreenViewModel());
  locator.registerFactory(() => EmailChangeScreenViewModel());
}