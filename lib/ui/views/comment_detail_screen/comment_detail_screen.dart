import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/custom_theme.dart';
import '../../../core/view_models/base_view_model.dart';
import '../../../core/view_models/comment_detail_screen_view_model.dart';
import '../../widgets/custom_snack_bar.dart';
import '../../widgets/loading_screen.dart';

class CommentDetailScreen extends StatefulWidget {
  final String? articleId;
  const CommentDetailScreen({Key? key, this.articleId}) : super(key: key);

  @override
  State<CommentDetailScreen> createState() => _CommentDetailScreenState();
}

class _CommentDetailScreenState extends State<CommentDetailScreen> {
  String textInput = "";

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<CommentDetailScreenViewModel>(context, listen: false).fetchArticleCommentsFromRemote(widget.articleId!);
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сэтгэгдлүүд', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.primaryPinkInRGB, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Consumer<CommentDetailScreenViewModel>(
          builder: (context, model, __) {
            if (model.state == ViewState.busy) {
              return const LoadingScreen();
            } else {
              return Column(
                children: [
                  Expanded(
                    child: model.comments.isEmpty 
                    ? const Padding(
                      padding: EdgeInsets.only(top:100, left: 20, right: 20, bottom: 20),
                      child: Text('Одоохондоо сэтгэгдэлгүй байна.'))
                    : ListView.separated(
                      separatorBuilder: (context, index) => const Divider(indent: 10.0, endIndent: 10.0, color: Colors.grey),
                      itemCount: model.comments.length + 1,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return (index == model.comments.length)
                        ? ElevatedButton(
                          child: model.hasReachedTheBottom ? const Text("дууссан") : const Text("үргэлжлүүлэх..."),
                          onPressed: () async {
                            await model.loadMoreArticleCommentsAndSet(lastCommentId: model.comments.last.id!, articleId: widget.articleId!);
                          },
                        )
                        : Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10.0),
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Text(model.comments[index].text ?? "", style: const TextStyle(fontSize: 16)),
                                ),
                                Row(
                                  children: [
                                    Text(model.comments[index].name?? "", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    const Text(' • '),
                                    Text(model.convertTime(model.comments[index].date ?? ""), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    height: 70,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLength: 500,
                            autocorrect: false,
                            onChanged: (value) { textInput = value; },
                            decoration: const InputDecoration(hintText: "Сэтгэгдэл нэмэх..."),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          iconSize: 25.0,
                          color: AppTheme.primaryPinkInRGB,
                          onPressed: () async {
                            if (textInput.trim().isEmpty) {
                              showDialog(
                                barrierDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(const Duration(seconds: 2), () {
                                      Navigator.of(context).pop();
                                    });
                                    return const AlertDialog(
                                      title: Text(
                                        "Сэтгэгдэл оруулна уу!",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300, fontSize: 14),
                                      ),
                                    );
                                  },
                                );
                              return;
                            }
                            final response = await Provider.of<CommentDetailScreenViewModel>(context, listen: false).addArticleComment(articleId: widget.articleId!, text: textInput.trim());
                            Future.delayed(Duration.zero).then((_) async {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(displaySnackBar(response.msg!));
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }
}