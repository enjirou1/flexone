import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/widgets/listtile/review_list_tile.dart';
import 'package:flutter/material.dart';

class ClassReviewScreen extends StatefulWidget {
  String classId;

  ClassReviewScreen({ Key? key, required this.classId }) : super(key: key);

  @override
  State<ClassReviewScreen> createState() => _ClassReviewScreenState();
}

class _ClassReviewScreenState extends State<ClassReviewScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Review> _reviews = [];
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('reviews').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Review>>(
          future: Class.getClassReviews(widget.classId, _reviews.length, 20),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Review> data = snapshot.data!;
      
              if (_reviews.isEmpty) {
                Future.delayed(Duration.zero, () {
                  _reviews.addAll(data);
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
                    List<Review> temp = [];
                    temp.addAll(_reviews);
                    _reviews.clear();
                    _reviews.addAll([...temp, ...data]);
                    data.clear();
                    setState(() {});
                  }
                }
              });
            }
      
            if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.zero,
                child: ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return (index < _reviews.length)
                      ? ReviewListTile(
                          image: _reviews[index].user.photo!, 
                          name: _reviews[index].user.name, 
                          id: _reviews[index].user.id, 
                          rating: _reviews[index].detail.rating, 
                          review: _reviews[index].detail.review!,
                        )
                      : const Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(),
                          ),
                        );
                  },
                  itemCount: (_hasReachedMax || _reviews.isEmpty) ? _reviews.length : _reviews.length + 1,
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
      ),
    );
  }
}