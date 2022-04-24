import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/discussion/add_answer_screen.dart';
import 'package:flexone/widgets/card/answer_card.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class QuestionDetailScreen extends StatefulWidget {
  Question question;

  QuestionDetailScreen({ Key? key, required this.question }) : super(key: key);

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Answer> _answers = [];
  bool _hasReachedMax = false;
  double _rating = 5.0;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.question.subject.name} (${widget.question.grade.name})', style: poppinsTheme.bodyText2),
            Text(tr('points', args: [widget.question.point.toString()]), style: poppinsTheme.caption)
          ],
        ),
      ),
      body: FutureBuilder<List<Answer>>(
        future: Question.getAnswers(_answers.length, 10, widget.question.questionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Answer> data = snapshot.data!;

            if (_answers.isEmpty) {
              Future.delayed(Duration.zero, () {
                _answers.addAll(data);
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
                  List<Answer> temp = [];
                  temp.addAll(_answers);
                  _answers.clear();
                  _answers.addAll([...temp, ...data]);
                  data.clear();
                  setState(() {});
                }
              }
            });
          }

          if (snapshot.hasData) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed('/user/detail?id=${widget.question.user.id}'),
                      child: Row(
                        children: [
                          (widget.question.user.photo != null && widget.question.user.photo != "")
                          ? Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                                image: DecorationImage(
                                  image: NetworkImage(widget.question.user.photo), 
                                  fit: BoxFit.cover
                                )
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                  image: AssetImage('assets/images/profile-icon.png'),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${widget.question.user.name} #${widget.question.user.id}', style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
                              Text(timeago.format(DateTime.parse(widget.question.createdAt), locale: 'en'), style: poppinsTheme.caption)
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    SelectableText(widget.question.text),
                    if (widget.question.photo != "") ...[
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () => Get.to(PreviewImage(image: widget.question.photo)),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: NetworkImage(widget.question.photo), 
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Text(tr('answers'), style: poppinsTheme.headline6),
                    const SizedBox(height: 10),
                    ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return (index < _answers.length)
                          ? AnswerCard(
                            answer: _answers[index],
                            onRatingPressed: () async {
                              bool checkRating = await Question.checkRating(_answers[index].answerId, _provider.user!.userId!);
                              if (checkRating && _provider.user!.userId! != _answers[index].user.id) {
                                showDialog(
                                  context: context, 
                                  builder: (context) => AlertDialog(
                                    title: Center(child: Text('Rating', style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),)),
                                    actions: [
                                      Center(
                                        child: RatingBar.builder(
                                          initialRating: 5,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ), 
                                          onRatingUpdate: (rating) {
                                            _rating = rating;
                                            setState(() {});
                                          }
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await Question.rating(_answers[index].answerId, _provider.user!.userId!, _rating.toString());
                                            _answers.clear();
                                            _hasReachedMax = false;
                                            setState(() {});
                                            Navigator.pop(context);
                                          }, 
                                          child: const Text('OK')
                                        ),
                                      )
                                    ],
                                  )
                                );
                              }
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
                      itemCount: _hasReachedMax ? _answers.length : _answers.length + 1,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
      floatingActionButton: (_provider.user!.userId! != widget.question.user.id) ? 
        FloatingActionButton(
          onPressed: () async {
            final result = await Get.to(AddAnswerScreen(question: widget.question));
            if (result != null) {
              _answers.clear();
              _hasReachedMax = false;
              setState(() {});
            }
          },
          child: const Icon(Icons.add),
        ) : null
    );
  }
}