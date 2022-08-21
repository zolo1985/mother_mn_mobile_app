import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../article_detail_screen/article_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/base_view_model.dart';
import '../../../core/view_models/home_screen_view_model.dart';

class LatestArticlesRow extends StatefulWidget {
  const LatestArticlesRow({Key? key}) : super(key: key);

  @override
  State<LatestArticlesRow> createState() => _LatestArticlesRowState();
}

class _LatestArticlesRowState extends State<LatestArticlesRow> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<HomeScreenViewModel>(context, listen: false).fetchArticlesFromRemote();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenViewModel>(
      builder: (context, model, __) {
        return model.state == ViewState.busy 
        ? SizedBox(
          height: MediaQuery.of(context).size.width,
          child: const Center(
            child: SpinKitFadingCircle(color: AppTheme.primaryPinkInRGB, size: 40.0)),
        )
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10, left:10, top: 20),
              child: Row(
                children: const [
                  FaIcon(FontAwesomeIcons.listCheck, color: AppTheme.primaryPinkInRGB,),
                  SizedBox(width: 5),
                  Text('Сүүлд нэмэгдсэн',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SizedBox(
              // color: Theme.of(context).backgroundColor,
              height: MediaQuery.of(context).size.width * 0.75,
              child: Scrollbar(
                thickness: 1,
                radius: const Radius.circular(10),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: model.articles.length,
                  itemBuilder: (BuildContext context, int index) {
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CachedNetworkImage(
                                key: UniqueKey(),
                                imageUrl: model.articles[index].artwork!,
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.width * 0.5,
                                width: MediaQuery.of(context).size.width * 0.6,
                                fadeOutDuration: const Duration(milliseconds: 300),
                                fadeOutCurve: Curves.decelerate,
                                placeholder: (context, url) => Container(color: Colors.grey),
                                errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                model.articles[index].title ?? "",
                                // textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              model.articles[index].categories.toString().replaceAll("[", "").replaceAll("]", ""),
                              // textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w300)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              model.articles[index].author ?? "",
                              // textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w300)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}