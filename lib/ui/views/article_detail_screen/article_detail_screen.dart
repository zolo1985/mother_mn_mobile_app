

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../comment_detail_screen/comment_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/article_detail_screen_view_model.dart';
import '../../../core/view_models/base_view_model.dart';
import '../../widgets/custom_snack_bar.dart';
import '../../widgets/loading_screen.dart';
import 'article_carousel.dart';


class ArticleDetailScreen extends StatefulWidget {
  final String articleId; 

  const ArticleDetailScreen({Key? key, required this.articleId}) : super(key: key);

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<ArticleDetailScreenViewModel>(context, listen: false).fetchArticleAndSet(widget.articleId);
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryPinkInRGB, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Нийтлэл", style: TextStyle(fontSize: 18)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: Theme.of(context).backgroundColor,
            child: Consumer<ArticleDetailScreenViewModel>(
              builder: (context, model, __) {
                if (model.state == ViewState.busy) {
                  return const LoadingScreen();
                } else {
                  final totalMin = model.article.content?.split(' ').length ?? 0;
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 10),
                        child: Text(model.article.title ?? "", textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Row(
                          children: [
                            if (model.article.authorArtwork != null)
                            CachedNetworkImage(
                              imageUrl: model.article.authorArtwork!,
                              imageBuilder: (context, imageProvider) =>
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              placeholder: (context, url) => const Icon(Icons.error, color: Colors.grey, size: 50),
                              errorWidget: (context, url, error) => const Icon(Icons.error, size: 50, color: Colors.grey),
                            )
                            else Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(Radius.circular(30))
                              ),
                              width: 50,
                              height: 50),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Нийтлэлч: ${model.article.author}', style: const TextStyle(fontWeight: FontWeight.w300),),
                                Text('Огноо: ${model.article.createdDate}', style: const TextStyle(fontWeight: FontWeight.w300),),
                                Text("Унших хугацаа: ${totalMin~/200} мин", style: const TextStyle(fontWeight: FontWeight.w300),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 15, bottom: 5, right: 20, left: 20),
                        child: Text("Ангилал: ${model.article.categories.toString().replaceAll("[", "").replaceAll("]", "")}", maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
                        child: Text("Түлхүүр үгс: ${model.article.tags.toString().replaceAll("[", "").replaceAll("]", "")}", maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ),
                      if (model.article.images!.isEmpty) Container() else SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Scrollbar(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 20, left: 20, top: 10),
                            // shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: model.article.images?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ArticleCarousel(
                                image: model.article.images![index],
                              );
                            }
                          ),
                        ),
                      ),
                      if (model.article.images!.isNotEmpty) ...[
                        if (model.article.images!.length > 1) ...[
                          const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.arrow_circle_right),
                            ),
                          ),
                        ]
                      ],
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 5),
                        child: Html(data: model.article.content, style: {
                          "p": Style(
                              textAlign: TextAlign.justify,
                              fontSize: FontSize.large,
                              fontWeight: FontWeight.w300,
                              lineHeight: LineHeight.number(1.5),
                            ),
                          "iframe": Style(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top:20, bottom:20)
                          ),
                          }
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: model.likeButtonState == LikeButtonNotifierState.loading ? const SizedBox(height: 15, width: 15, child: SpinKitFadingCircle(color: AppTheme.primaryPinkInRGB, size: 40.0)) : model.likeButtonState == LikeButtonNotifierState.loaded && model.isLiked
                                ? const FaIcon(FontAwesomeIcons.heart, color: AppTheme.primaryPinkInRGB,)
                                : const FaIcon(FontAwesomeIcons.heart, color: AppTheme.primaryPinkInRGB,),
                              onPressed: () async {
                                context.read<ArticleDetailScreenViewModel>().toggleIsLiked();
                                final response = await model.likeOrUnlikeArticle(articleId: model.article.id!);
                                Future.delayed(Duration.zero).then((_) async {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(displaySnackBar(response.msg!));
                                });
                              },
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.comment, color: AppTheme.primaryPinkInRGB,),
                              onPressed: () async {
                                Future.delayed(Duration.zero).then((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => CommentDetailScreen(articleId: model.article.id),),
                                  );
                                });
                              },
                            ),
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.shareFromSquare, color: AppTheme.primaryPinkInRGB,),
                              onPressed: () async {
                                await model.onShare(context, model.article.title!);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}