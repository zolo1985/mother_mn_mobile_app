import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/view_models/account_settings_screen_view_model.dart';
import 'core/view_models/email_change_screen_view_model.dart';
import 'core/view_models/password_change_screen_view_model.dart';
import 'ui/views/fav_screen/fav_screen.dart';
import 'ui/views/home_screen/home_screen.dart';
import 'ui/views/search_screen/search_screen.dart';
import 'ui/views/signin_screen/signin_screen.dart';
import 'package:provider/provider.dart';

import 'core/constants/custom_theme.dart';
import 'core/services/user_repository_service.dart';
import 'core/view_models/article_detail_screen_view_model.dart';
import 'core/view_models/category_articles_screen_view_model.dart';
import 'core/view_models/comment_detail_screen_view_model.dart';
import 'core/view_models/fav_screen_view_model.dart';
import 'core/view_models/home_screen_view_model.dart';
import 'core/view_models/publishers_screen_model.dart';
import 'core/view_models/search_screen_view_model.dart';
import 'core/view_models/signin_screen_view_model.dart';
import 'core/view_models/signup_screen_view_model.dart';
import 'core/view_models/tag_articles_view_model.dart';
import 'locator.dart';

void main() async {
  await setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  final bool isLoggedIn = await locator<UserRepositoryService>().isAuthorized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MotherApp(isAuthenticated: isLoggedIn));
  });
}

class MotherApp extends StatelessWidget {
  final bool isAuthenticated;
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  const MotherApp({Key? key, required this.isAuthenticated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [   
        ChangeNotifierProvider(create: (ctx) => HomeScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => FavScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => SearchScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => CategoryArticlesScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => TagArticlesScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => PublishersScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => ArticleDetailScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => CommentDetailScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => SignInScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => SignUpScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => AccountSettingsScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => PasswordChangeScreenViewModel()),
        ChangeNotifierProvider(create: (ctx) => EmailChangeScreenViewModel()),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: currentMode,
            home: isAuthenticated ? const MotherMainPage(): const SignInScreen()
            // home: const MotherMainPage(),
          );
        }
      ),
    );
  }
}

class MotherMainPage extends StatefulWidget {
  const MotherMainPage({Key? key}) : super(key: key);

  @override
  State<MotherMainPage> createState() => _MotherMainPageState();
}

class _MotherMainPageState extends State<MotherMainPage> with WidgetsBindingObserver {
  GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey();
  GlobalKey<NavigatorState> favNavigatorKey = GlobalKey();
  GlobalKey<NavigatorState> searchNavigatorKey = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) return;
    final isClosing = state == AppLifecycleState.detached;

    if (isClosing) {
    }

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      //close DATABASE?
      
    } else {
      //open DATABASE?
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            Navigator(
              key: homeNavigatorKey,
              onGenerateRoute: (RouteSettings settings) =>
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
            ),
            Navigator(
              key: searchNavigatorKey,
              onGenerateRoute: (RouteSettings settings) =>
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
            ),
            Navigator(
              key: favNavigatorKey,
              onGenerateRoute: (RouteSettings settings) =>
                  MaterialPageRoute(builder: (context) => const FavScreen()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomNavigationBar(
            fixedColor: AppTheme.primaryPinkInRGB,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: allDestinations.map((Destination destination) {
              return BottomNavigationBarItem(
                icon: Icon(destination.icon),
                backgroundColor: Colors.black,
                label: destination.title,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class Destination {
  const Destination(this.title, this.icon);
  final String title;
  final IconData icon;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Үндсэн', Icons.home),
  Destination('Хайх', Icons.search),
  Destination('Миний', Icons.favorite),
];
