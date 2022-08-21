import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../category_articles_screen/category_articles_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/base_view_model.dart';
import '../../../core/view_models/home_screen_view_model.dart';

class CategoriesRow extends StatefulWidget {
  const CategoriesRow({Key? key}) : super(key: key);

  @override
  State<CategoriesRow> createState() => _CategoriesRowState();
}

class _CategoriesRowState extends State<CategoriesRow> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<HomeScreenViewModel>(context, listen: false).fetchCategoriesFromRemote();
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
                children: const <Widget> [
                  FaIcon(FontAwesomeIcons.caretDown, color: AppTheme.primaryPinkInRGB,),
                  SizedBox(width: 5),
                  Text('Ангилал',
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
                itemCount: model.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      Future.delayed(Duration.zero).then((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CategoryArticlesScreen(categoryId: model.categories[index].id!, categoryName: model.categories[index].name!),),
                        );
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryPinkInRGB,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                        child: Text(
                          model.categories[index].name ?? "",
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