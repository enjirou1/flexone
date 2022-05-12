import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/utils/launcher.dart';
import 'package:flexone/widgets/card/my_class_card.dart';
import 'package:flexone/widgets/card/my_consultation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MyClassScreen extends StatefulWidget {
  const MyClassScreen({ Key? key }) : super(key: key);

  @override
  State<MyClassScreen> createState() => _MyClassScreenState();
}

class _MyClassScreenState extends State<MyClassScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  List<Class> _classes = [];
  bool _hasReachedMax = false;
  double _rating = 5.0;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('my_classes').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Class>>(
          future: Class.getClassesJoined(_provider.user!.userId!, _classes.length, 20),
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
              return ListView.separated(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return (index < _classes.length)
                    ? MyClassCard(
                        classModel: _classes[index],
                        onGiveRating: () {
                          BuildContext parentContext = context;
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
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: TextField(
                                    controller: _controller,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: tr("review"),
                                      labelStyle: const TextStyle(color: Colors.black),
                                      isDense: true
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await Class.giveRating(
                                        _classes[index].id,
                                        _provider.user!.userId!,
                                        _rating.toInt(), 
                                        _controller.text
                                      );
                                      _classes.clear();
                                      _hasReachedMax = false;
                                      setState(() {});
                                      Navigator.pop(context);
                                      Navigator.pop(parentContext);
                                    }, 
                                    child: const Text('OK')
                                  ),
                                )
                              ],
                            )
                          );
                        },
                        onViewReview: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context, 
                            builder: (context) => AlertDialog(
                              title: Center(child: Text('Rating', style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),)),
                              actions: [
                                Center(
                                  child: RatingBarIndicator(
                                    rating: _classes[index].detail!.rating.toDouble(),
                                    unratedColor: Colors.grey,
                                    itemBuilder: (context, index) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 30,
                                    direction: Axis.horizontal,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(_classes[index].detail!.review!, style: poppinsTheme.bodyText2!.copyWith(color: Colors.black)),
                                  )
                                ),
                                const SizedBox(height: 20),
                              ],
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
                itemCount: (_hasReachedMax || _classes.isEmpty) ? _classes.length : _classes.length + 1,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
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