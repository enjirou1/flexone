import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/class/filter_screen.dart';
import 'package:flexone/widgets/card/class_card.dart';
import 'package:flexone/widgets/edittext/search_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({ Key? key }) : super(key: key);

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Class> _classes = [];
  String _keywords = "";
  int? _lowest = null, _highest = null, _rating = null, _subject = null, _grade = null;
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SearchEditText(
            controller: _controller,
            onSubmitted: (String value) {
              _keywords = value;
              _lowest = null;
              _highest = null;
              _rating = null;
              _subject = null;
              _grade = null;
              _classes.clear();
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

              _lowest = null;
              _highest = null;
              _rating = null;
              _subject = null;
              _grade = null;
              _classes.clear();
              _hasReachedMax = false;

              setState(() {});
            },
            onPressed: () async {
              final result = await Get.to(const FilterScreen());
              if (result != null) {
                _lowest = result['lowest'] == null ? null : int.parse(result['lowest']);
                _highest = result['highest'] == null ? null : int.parse(result['highest']);
                _rating = result['rating'] == null ? null : int.parse(result['rating']);
                _subject = result['subject'];
                _grade = result['grade'];
                _classes.clear();
                setState(() {});
              }
            }
          ),
          Expanded(
            child: FutureBuilder<List<Class>>(
              future: Class.getClasses(_classes.length, 20, _keywords, _rating, _lowest, _highest, _grade, _subject, _provider.user?.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Class> data = snapshot.data!;
          
                  if (_classes.isEmpty) {
                    Future.delayed(Duration.zero, () {
                      _classes.addAll(data);
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
                        List<Class> temp = [];
                        temp.addAll(_classes);
                        _classes.clear();
                        _classes.addAll([...temp, ...data]);
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
                        return (index < _classes.length)
                          ? ClassCard(classModel: _classes[index])
                          : const Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(),
                              ),
                            );
                      },
                      itemCount: (_hasReachedMax || _classes.isEmpty) ? _classes.length : _classes.length + 1,
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