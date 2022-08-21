import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/models/article_image.dart';


class ArticleCarousel extends StatelessWidget {
  final ArticleImage? image;

  const ArticleCarousel({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          key: UniqueKey(),
          imageUrl: image!.imageUrl!,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.width,
          fadeOutDuration: const Duration(milliseconds: 300),
          fadeOutCurve: Curves.decelerate,
          placeholder: (context, url) => Container(color: Colors.grey),
          errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image,size: 50, color: Colors.grey,)),
        ),
      ),
    );
  }
}
