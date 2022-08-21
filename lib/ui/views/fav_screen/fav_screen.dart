import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/base_view_model.dart';
import '../../../core/view_models/fav_screen_view_model.dart';
import '../../widgets/loading_screen.dart';
import '../about_us_screen/about_us_screen.dart';
import '../article_detail_screen/article_detail_screen.dart';
import '../faq_screen/faq_screen.dart';
import '../publishers_screen/publisher_screen.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<FavScreenViewModel>(context, listen: false).fetchArticlesFromRemote();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mother', style: TextStyle(fontFamily: 'GreatVibes', fontSize: 40, fontWeight: FontWeight.w300),),
        centerTitle: true,
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
      body: SafeArea(
        child: Consumer<FavScreenViewModel>(
          builder: (context, model, __) {
            if (model.state == ViewState.busy) {
              return const LoadingScreen();
            } else {
              return RefreshIndicator(
                color: AppTheme.primaryPinkInRGB,
                onRefresh: () => model.fetchArticlesFromRemote(),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  itemCount: model.articles.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (model.articles.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: const Center(child: Text('Одоохондоо таньд таалагдсан нийтлэл байхгүй байна', style: TextStyle(fontSize: 16),))),
                      );
                    } else {
                      if (index == 0) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              children: const [
                                FaIcon(FontAwesomeIcons.heart, color: AppTheme.primaryPinkInRGB,),
                                SizedBox(width: 5),
                                Text("Таалагдсан нийтлэлүүд", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                              ],
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                Future.delayed(Duration.zero).then((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ArticleDetailScreen(articleId: model.articles[index].id!),),
                                  );
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top:5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: CachedNetworkImage(
                                        key: UniqueKey(),
                                        imageUrl: model.articles[index].artwork!,
                                        fit: BoxFit.cover,
                                        height: MediaQuery.of(context).size.width / 4,
                                        width: MediaQuery.of(context).size.width / 4,
                                        fadeOutDuration: const Duration(milliseconds: 300),
                                        placeholder: (context, url) => const Icon(Icons.image, color: Colors.grey, size: 30.0),
                                        errorWidget:(context, url, error) => const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 4 - 30,
                                          child: Text(
                                            model.articles[index].title!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 4 - 30,
                                          child: Text(
                                            model.articles[index].author!,
                                            maxLines: 1,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 4 - 30,
                                          child: Text(
                                            model.articles[index].categories.toString(),
                                            maxLines: 1,
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            Future.delayed(Duration.zero).then((_) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ArticleDetailScreen(articleId: model.articles[index].id!),),
                              );
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top:5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: CachedNetworkImage(
                                    key: UniqueKey(),
                                    imageUrl: model.articles[index].artwork!,
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.width / 4,
                                    width: MediaQuery.of(context).size.width / 4,
                                    fadeOutDuration: const Duration(milliseconds: 300),
                                    placeholder: (context, url) => const Icon(Icons.image, color: Colors.grey, size: 30.0),
                                    errorWidget:(context, url, error) => const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 4 - 30,
                                      child: Text(
                                        model.articles[index].title!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 4 - 30,
                                      child: Text(
                                        model.articles[index].author!,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 4 - 30,
                                      child: Text(
                                        model.articles[index].categories.toString(),
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              );
            }
          }
        ),
      ),
    );
  }
}