import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/view_models/home_screen_view_model.dart';
import '../about_us_screen/about_us_screen.dart';
import '../account_settings_screen/account_settings_screen.dart';
import 'categories_row.dart';
import 'latest_articles_row.dart';
import 'most_liked_articles.dart';
import 'most_read_articles.dart';
import 'tags_row.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../faq_screen/faq_screen.dart';
import '../publishers_screen/publisher_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _pullRefresh(BuildContext context) async {
    await Provider.of<HomeScreenViewModel>(context, listen: false).fetchArticlesFromRemote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mother', style: TextStyle(fontFamily: 'GreatVibes', fontSize: 40, fontWeight: FontWeight.w300),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {
            // final db = MotherDB.instance;
            // final value = await db.getUserToken();
            // // ignore: avoid_print
            // print(value);

            Future.delayed(Duration.zero).then((_) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountSettingsScreen(),),
              );
            });

            // final LocalStorageRepositoryService _localService = locator<LocalStorageRepositoryService>();
            // final user = await _localService.readUser("4d1100da-8e7d-4507-b3e8-3701e1395bdc");
            // print(user.localId);
            // print(user.id);
            // print(user.email);
            // print(user.phone);
            // print(user.accessToken);
            // print(user.refreshToken);
            // print(user.isAuthenticated);
          }, icon: const FaIcon(FontAwesomeIcons.user, color: AppTheme.primaryPinkInRGB, size: 20),)
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.primaryPinkInRGB,
        onRefresh: () => _pullRefresh(context),
        displacement: 80,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: const [
                  LatestArticlesRow(),
                  CategoriesRow(),
                  MostReadArticlesRow(),
                  TagsRow(),
                  MostLikedArticlesRow(),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [

            const DrawerHeader(
              child: Center(child: Text('Mother', style: TextStyle(fontSize: 40, fontFamily: "GreatVibes"),)),
            ),
            
            ListTile(
              horizontalTitleGap: 0,
              leading: const FaIcon(FontAwesomeIcons.pencil, color: AppTheme.primaryPinkInRGB, size: 16),
              title: const Text('Нийтлэлчид'),
              onTap: () {
                Future.delayed(Duration.zero).then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PublishersScreen(),),
                  );
                });
              },
            ),

            ListTile(
              horizontalTitleGap: 0,
              leading: const FaIcon(FontAwesomeIcons.userGroup, color: AppTheme.primaryPinkInRGB, size: 16),
              title: const Text('Бидний тухай'),
              onTap: () {
                Future.delayed(Duration.zero).then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutUsScreen(),),
                  );
                });
              },
            ),

            ListTile(
              horizontalTitleGap: 0,
              leading: const FaIcon(FontAwesomeIcons.solidCircleQuestion, color: AppTheme.primaryPinkInRGB, size: 16),
              title: const Text('НАХ'),
              onTap: () {
                Future.delayed(Duration.zero).then((_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FAQScreen(),),
                  );
                });
              },
            ),
            
            ListTile(
              horizontalTitleGap: 0,
              leading: const Icon(Icons.email, color: AppTheme.primaryPinkInRGB, size: 20),
              title: const Text('Холбоо барих'),
              subtitle: const Text("mothermn@gmail.com"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }
}