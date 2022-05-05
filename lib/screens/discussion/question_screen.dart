import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/widgets/card/question_card.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flexone/widgets/edittext/search_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({ Key? key }) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Question> _questions = [];
  String _keywords = "";
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final Color _textColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('my_questions').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SearchEditText(
              controller: _controller,
              onSubmitted: (String value) {
                _keywords = value;
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
                _questions.clear();
                _hasReachedMax = false;
                setState(() {});
              },
            ),
            Expanded(
              child: FutureBuilder<List<Question>>(
                future: Question.getQuestions(_questions.length, 20, _keywords, 0, 0, _provider.user!.userId),
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
                    if (snapshot.data!.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ListView.separated(
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            return (index < _questions.length)
                              ? QuestionCard(
                                  question: _questions[index],
                                  userId: _provider.user!.userId!,
                                  onRemoved: () {
                                    showDialog(
                                      context: context, 
                                      builder: (context) => ConfirmationDialog(
                                        title: 'confirmation.delete_question.title',
                                        buttonText: 'delete', 
                                        onCancel: () {
                                          Navigator.pop(context);
                                        }, 
                                        onPressed: () async {
                                          await Question.deleteQuestion(_questions[index].questionId);
                                          _questions.removeAt(index);
                                          Navigator.pop(context);
                                          setState(() {});
                                        }
                                      )
                                    );
                                  },
                                )
                              : const Center(
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                          },
                          itemCount: (_hasReachedMax || _questions.isEmpty) ? _questions.length : _questions.length + 1,
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("empty_text.my_questions", style: poppinsTheme.bodyText1).tr(),
                      );
                    }
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.toNamed('add_question');
          if (result != null) {
            _questions.clear();
            _hasReachedMax = false;
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}