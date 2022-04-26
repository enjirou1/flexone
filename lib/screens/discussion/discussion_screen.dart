import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/discussion/filter_screen.dart';
import 'package:flexone/widgets/card/question_card.dart';
import 'package:flexone/widgets/edittext/search_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({ Key? key }) : super(key: key);

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Question> _questions = [];
  String _keywords = "";
  int _grade = 0, _subject = 0;
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SearchEditText(
            controller: _controller,
            onSubmitted: (String value) {
              _keywords = value;
              _grade = 0;
              _subject = 0;
              _questions.clear();
              _hasReachedMax = false;
              setState(() {});
            },
            onChanged: (String value) {
              _keywords = value;
              setState(() {});
            },
            onClear: () {
              if (_keywords != "") {
                _controller.text = "";
                _keywords = "";
              }

              _grade = 0;
              _subject = 0;
              _questions.clear();
              _hasReachedMax = false;

              setState(() {});
            },
            onPressed: () async {
              final result = await Get.to(const FilterScreen());
              if (result != null) {
                _grade = result['grade'];
                _subject = result['subject'];
                _questions.clear();
                setState(() {});
              }
            }
          ),
          Expanded(
            child: FutureBuilder<List<Question>>(
              future: Question.getQuestions(_questions.length, 20, _keywords, _grade, _subject, null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Question> data = snapshot.data!;
          
                  if (_questions.isEmpty) {
                    Future.delayed(Duration.zero, () {
                      _questions.addAll(data);
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
                        List<Question> temp = [];
                        temp.addAll(_questions);
                        _questions.clear();
                        _questions.addAll([...temp, ...data]);
                        data.clear();
                        setState(() {});
                      }
                    }
                  });
                }
          
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return (index < _questions.length)
                          ? QuestionCard(question: _questions[index], userId: _provider.user?.userId)
                          : const Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(),
                              ),
                            );
                      },
                      itemCount: _hasReachedMax ? _questions.length : _questions.length + 1,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              }
            ),
          )
        ],
      ),
    );
  }
}