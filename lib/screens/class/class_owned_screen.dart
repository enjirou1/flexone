import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/class/edit_class_screen.dart';
import 'package:flexone/widgets/card/class_card.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flexone/widgets/edittext/search_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ClassOwnedScreen extends StatefulWidget {
  const ClassOwnedScreen({ Key? key }) : super(key: key);

  @override
  State<ClassOwnedScreen> createState() => _ClassOwnedScreenState();
}

class _ClassOwnedScreenState extends State<ClassOwnedScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Class> _classes = [];
  String _keywords = "";
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('classes_owned').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SearchEditText(
              controller: _controller,
              onSubmitted: (String value) {
                _keywords = value;
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
                _classes.clear();
                _hasReachedMax = false;

                setState(() {});
              }
            ),
            Expanded(
              child: FutureBuilder<List<Class>>(
                future: Class.getClassesOwned(_provider.user!.expertId!, _classes.length, 20, _keywords),
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
                            ? ClassCard(
                                classModel: _classes[index],
                                onRemoved: () async {
                                  showDialog(
                                    context: context, 
                                    builder: (context) => ConfirmationDialog(
                                      title: 'confirmation.delete_class.title',
                                      buttonText: 'delete', 
                                      onCancel: () {
                                        Navigator.pop(context);
                                      }, 
                                      onPressed: () async {
                                        await Class.deleteClass(_classes[index].id);
                                        _classes.clear();
                                        setState(() {});
                                        Navigator.pop(context);
                                      }
                                    )
                                  );
                                },
                                onUpdated: () async {
                                  final result = await Get.to(EditClassScreen(classModel: _classes[index]));
                                  if (result != null) {
                                    _classes.clear();
                                    _hasReachedMax = false;
                                    setState(() {});
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
                        itemCount: _hasReachedMax ? _classes.length : _classes.length + 1,
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
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Get.toNamed('/add_class');
          if (result != null) {
            _classes.clear();
            _hasReachedMax = false;
            setState(() {});
          }
        },
      ),
    );
  }
}