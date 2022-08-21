import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../core/constants/custom_theme.dart';
import 'package:provider/provider.dart';

import '../../../core/models/search_result.dart';
import '../../../core/services/remote_storage_repository_service.dart';
import '../../../core/view_models/search_screen_view_model.dart';
import '../../../locator.dart';
import '../../widgets/custom_snack_bar.dart';
import '../about_us_screen/about_us_screen.dart';
import '../article_detail_screen/article_detail_screen.dart';
import '../faq_screen/faq_screen.dart';
import '../publishers_screen/publisher_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<SearchScreenViewModel>(context, listen: false).fetchArticlesFromRemote();
    });
    super.initState();
  }

  Future<void> _pullRefresh(BuildContext context) async {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<SearchScreenViewModel>(context, listen: false).fetchArticlesFromRemote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mother', style: TextStyle(fontFamily: 'GreatVibes', fontSize: 40, fontWeight: FontWeight.w300),),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: Container(
            margin: const EdgeInsets.only(bottom: 5, left: 15, right: 15),
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0, padding: EdgeInsets.zero, primary: Theme.of(context).colorScheme.onPrimary),
              onPressed: () async {
                if (await InternetConnectionChecker().hasConnection) {
                  showSearch(context: context, delegate: SearchContent());
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(displaySnackBar('Сүлжээгүй байна!'));
                }
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Icon(
                      Icons.search,
                      size: 24.0,
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text("Хайх...",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).backgroundColor),
                  ),
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
      body: RefreshIndicator(
        color: AppTheme.primaryPinkInRGB,
        onRefresh: () => _pullRefresh(context),
        displacement: 60,
        child: Consumer<SearchScreenViewModel>(
          builder: (context, model, __) {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: model.articles.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (model.articles.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(child: Text('Одоохондоо нийтлэл ороогүй байна', style: TextStyle(fontSize: 16),))),
                  );
                } else {
                  return (index == model.articles.length)
                  ? ElevatedButton(
                      child: model.hasReachedTheBottom ? const Text("дуусав.") : const Text("цааш нь.."),
                      onPressed: () async {
                        await model.loadMoreArticlesAndSet(lastArticleId: model.articles.last.id!);
                      },
                    )
                  : GestureDetector(
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
              },
            );
          }
        ),
      ),
    );
  }
}

class SearchContent extends SearchDelegate {
  final RemoteStorageRepositoryService _remoteService = locator<RemoteStorageRepositoryService>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        // color: AppTheme.primaryPinkInRGB,
        onPressed: () { query = "";},
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios,
        color: AppTheme.primaryPinkInRGB,
        size: 20,
        ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }


  @override
  String get searchFieldLabel => 'Хайх..';

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length < 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text(
              "Хамгийн багадаа 2 тэмдэгт оруулна уу!",
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      );
    }
    Future.delayed(Duration.zero).then((_) async {
      // _remoteService.sendSearchActivity(query);
      // _localService.saveUserSearchHistoryToDatabase(query);
    });
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      child: FutureBuilder(
        future: _remoteService.search(query.trim()),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryPinkInRGB),
              ),
            );
          }
          if (snapshot.data == null) return const Text("");
          final List<SearchResult> results = snapshot.data as List<SearchResult>;
          return results.isEmpty
            ? const Center(child: Text('Юм олдсонгүй :('))
            : ListView.builder(
                itemCount: results.length,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final SearchResult result = results[index];
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        Future.delayed(Duration.zero).then((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ArticleDetailScreen(articleId: results[index].id!),),
                          );
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CachedNetworkImage(
                                key: UniqueKey(),
                                imageUrl: result.artwork!,
                                fit: BoxFit.cover,
                                height: 80,
                                width: 80,
                                fadeOutDuration:const Duration(milliseconds: 300),
                                fadeOutCurve: Curves.decelerate,
                                placeholder: (context, url) => Container(color: Colors.grey),
                                errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image,size: 80, color: Colors.grey)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result.title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w300),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      "нийтлэл",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final items =  ["first", "second", "third", "fourth", "fifth", "sixth"];
    // Future.delayed(Duration.zero).then((_) async {
    //   await Provider.of<SearchScreenViewModel>(context, listen: false).fetchSearchHistory();
    // });
    // final suggestions = query.isEmpty ? items : items.where((element) => element.searchQuery!.startsWith(query)).toList();

    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          // leading: const Icon(Icons.punch_clock),
          title: Row(
            children: [
              const Icon(Icons.history),
              const SizedBox(width: 5),
              Text(items[index]),
            ],
          ),
          onTap: () {
            query = items[index];
          },
        );
      }
    );
  }
}