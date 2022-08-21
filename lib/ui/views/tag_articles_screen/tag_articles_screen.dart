import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/base_view_model.dart';
import '../../../core/view_models/tag_articles_view_model.dart';
import '../../widgets/loading_screen.dart';
import '../article_detail_screen/article_detail_screen.dart';

class TagArticlesScreen extends StatefulWidget {
  final String tagId;
  final String tagTitle;
  const TagArticlesScreen({Key? key, required this.tagId, required this.tagTitle}) : super(key: key);

  @override
  State<TagArticlesScreen> createState() => _TagArticlesScreenState();
}

class _TagArticlesScreenState extends State<TagArticlesScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<TagArticlesScreenViewModel>(context, listen: false).fetchArticlesFromRemote(widget.tagId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_ios)),
        title: Text("${widget.tagTitle} нийтлэлүүд", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<TagArticlesScreenViewModel>(
          builder: (context, model, __) {
            if (model.state == ViewState.busy) {
              return const LoadingScreen();
            } else {
              return RefreshIndicator(
                color: AppTheme.primaryPinkInRGB,
                onRefresh: () => model.fetchArticlesFromRemote(widget.tagId),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: model.articles.length+1,
                  itemBuilder: (BuildContext context, int index) {
                    if (model.articles.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Center(child: Text('Одоохондоо ${widget.tagTitle.toUpperCase()} ангиллын нийтлэл ороогүй байна', style: const TextStyle(fontSize: 16),))),
                      );
                    } else {
                      return (index == model.articles.length) 
                        ? ElevatedButton(
                            child: model.hasReachedTheBottom ? const Text("дуусав") : const Text("цааш нь.."),
                            onPressed: () async {
                              await model.loadMoreArticlesAndSet(lastArticleId: model.articles.last.id!, tagId: widget.tagId);
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
                ),
              );
            }
          }
        ),
      ),
    );
  }
}