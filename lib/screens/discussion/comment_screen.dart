import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/widgets/card/comment_card.dart';
import 'package:flexone/widgets/edittext/chat_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  Answer answer;

  CommentScreen({ Key? key, required this.answer }) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Comment> _comments = [];
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: Question.getComments(_comments.length, 20, widget.answer.answerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Comment> data = snapshot.data!;

                  if (_comments.isEmpty) {
                    Future.delayed(Duration.zero, () {
                      _comments.addAll(data);
                      data = [];
                      setState(() {});
                    });
                  }

                  if (data.isEmpty) {
                    Future.delayed(Duration.zero, () {
                      _hasReachedMax = true;
                      data = [];
                      setState(() {});
                    });
                  }

                  _scrollController.addListener(() {
                    double currentScroll = _scrollController.position.pixels;
                    double maxScroll = _scrollController.position.maxScrollExtent;

                    if (currentScroll == maxScroll) {
                      if (!_hasReachedMax) {
                        List<Comment> temp = [];
                        temp.addAll(_comments);
                        _comments.clear();
                        _comments.addAll([...temp, ...data]);
                        data.clear();
                        setState(() {});
                      }
                    }
                  });
                }

                if (snapshot.hasData) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, top: 50, right: 10, bottom: 20),
                          width: double.infinity,
                          color: Colors.indigo[200],
                          child: SelectableText(widget.answer.text),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('comments', style: poppinsTheme.headline6).tr(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          child: ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return (index < _comments.length)
                                ? CommentCard(comment: _comments[index])
                                : const Center(
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                            },
                            itemCount: (_hasReachedMax || _comments.isEmpty) ? _comments.length : _comments.length + 1,
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider();
                            },
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }
              },
            )
          ),
          ChatEditText(
            controller: _controller, 
            enabled: _provider.user != null,
            onSubmit: () async {
              if (_controller.text.isNotEmpty) {
                await Question.comment(widget.answer.answerId, _provider.user!.userId!, _controller.text);
                _comments.clear();
                _controller.clear();
                _hasReachedMax = false;
                setState(() {});
              }
            },
          )
        ]
      ),
    );
  }
}