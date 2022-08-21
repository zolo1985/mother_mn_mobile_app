import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/base_view_model.dart';
import '../../../core/view_models/publishers_screen_model.dart';
import '../../widgets/loading_screen.dart';

class PublishersScreen extends StatefulWidget {
  const PublishersScreen({Key? key}) : super(key: key);

  @override
  State<PublishersScreen> createState() => _PublishersScreenState();
}

class _PublishersScreenState extends State<PublishersScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<PublishersScreenViewModel>(context, listen: false).fetchPublishersFromRemote();
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
        title: const Text("Нийтлэлчид", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<PublishersScreenViewModel>(
          builder: (context, model, __) {
            if (model.state == ViewState.busy) {
              return const LoadingScreen();
            } else {
              return RefreshIndicator(
                color: AppTheme.primaryPinkInRGB,
                onRefresh: () => model.fetchPublishersFromRemote(),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  physics: const BouncingScrollPhysics(),
                  itemCount: model.publishers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
  
                      },
                      child: Card(
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                if (model.publishers[index].avatarId != null) ...[
                                  ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    key: UniqueKey(),
                                    imageUrl: model.publishers[index].avatarId!,
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    fadeOutDuration: const Duration(milliseconds: 300),
                                    placeholder: (context, url) => const Icon(Icons.image, color: Colors.grey, size: 30.0),
                                    errorWidget:(context, url, error) => const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)),
                                  )
                                ),
                                ] else ...[
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(Radius.circular(8))
                                    ),
                                    height: 100,
                                    width: 100,
                                    child: const Icon(Icons.image, size: 50),
                                  )
                                ],
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(model.publishers[index].username ?? "", style: const TextStyle(fontSize: 20),),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Нийтлэлийн тоо: ${model.publishers[index].totalArticles.toString()}",
                                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                              child: Text(
                                model.publishers[index].bio ?? "",
                                style: TextStyle(color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.twitter, color: AppTheme.primaryPinkInRGB,),),
                                IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.instagram, color: AppTheme.primaryPinkInRGB,),),
                                IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.facebook, color: AppTheme.primaryPinkInRGB,),),
                              ],
                            ),
                          ],
                        )
                      ),
                    );
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