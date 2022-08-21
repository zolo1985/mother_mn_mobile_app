import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../tag_articles_screen/tag_articles_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/base_view_model.dart';
import '../../../core/view_models/home_screen_view_model.dart';

class TagsRow extends StatefulWidget {
  const TagsRow({Key? key}) : super(key: key);

  @override
  State<TagsRow> createState() => _TagsRowState();
}

class _TagsRowState extends State<TagsRow> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<HomeScreenViewModel>(context, listen: false).fetchTagsFromRemote();
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
                  FaIcon(FontAwesomeIcons.tag, color: AppTheme.primaryPinkInRGB,),
                  SizedBox(width: 5),
                  Text('Түлхүүр үгс',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: model.tags.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      Future.delayed(Duration.zero).then((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TagArticlesScreen(tagId: model.tags[index].id!, tagTitle: model.tags[index].title!),),
                        );
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 22, 97, 183),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                        
                        child: Text(
                          model.tags[index].title ?? "",
                          // textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400, fontStyle: FontStyle.italic, color: Colors.white)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}