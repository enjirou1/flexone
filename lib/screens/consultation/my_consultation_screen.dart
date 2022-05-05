import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/utils/launcher.dart';
import 'package:flexone/widgets/card/my_consultation_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MyConsultationScreen extends StatefulWidget {
  const MyConsultationScreen({ Key? key }) : super(key: key);

  @override
  State<MyConsultationScreen> createState() => _MyConsultationScreenState();
}

class _MyConsultationScreenState extends State<MyConsultationScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _controller = TextEditingController();
  List<Consultation> _consultations = [];
  bool _hasReachedMax = false;
  double _rating = 5.0;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('my_consultations').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Consultation>>(
          future: Consultation.getConsultationsJoined(_provider.user!.userId!, _consultations.length, 20),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Consultation> data = snapshot.data!;
    
              if (_consultations.isEmpty) {
                Future.delayed(Duration.zero, () {
                  _consultations.addAll(data);
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
                    List<Consultation> temp = [];
                    temp.addAll(_consultations);
                    _consultations.clear();
                    _consultations.addAll([...temp, ...data]);
                    data.clear();
                    setState(() {});
                  }
                }
              });
            }
    
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return (index < _consultations.length)
                      ? MyConsultationCard(
                          consultation: _consultations[index],
                          onGiveRating: () {
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
                                        await Consultation.giveRating(
                                          _consultations[index].detail!.id, 
                                          _consultations[index].id, 
                                          _rating.toInt(), 
                                          _controller.text
                                        );
                                        _consultations.clear();
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
                          },
                          onViewReview: () {
                            showDialog(
                              context: context, 
                              builder: (context) => AlertDialog(
                                title: Center(child: Text('Rating', style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),)),
                                actions: [
                                  Center(
                                    child: RatingBarIndicator(
                                      rating: _consultations[index].detail!.rating.toDouble(),
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
                                      child: Text(_consultations[index].detail!.review!, style: poppinsTheme.bodyText2!.copyWith(color: Colors.black)),
                                    )
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              )
                            );
                          },
                          onViewDetail: () {
                            showDialog(
                              context: context, 
                              builder: (context) => AlertDialog(
                                title: Center(child: Text('rejection_detail', style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold)).tr()),
                                actions: [
                                  Center(
                                    child: Text(
                                      _consultations[index].detail!.reason!,
                                      style: poppinsTheme.bodyText2!.copyWith(color: Colors.black),
                                    )
                                  ),
                                  const SizedBox(height: 20)
                                ],
                              )
                            );
                          },
                          onConsult: () {
                            Launcher.launchExternalApplication(_consultations[index].link);
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
                  itemCount: (_hasReachedMax || _consultations.isEmpty) ? _consultations.length : _consultations.length + 1,
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                );
              } else {
                return Center(
                  child: Text("empty_text.my_consultations", style: poppinsTheme.bodyText1).tr(),
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
      ),
    );
  }
}