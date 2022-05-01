import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/widgets/card/class_review_card.dart';
import 'package:flexone/widgets/card/consultation_review_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({ Key? key }) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Consultation> _consultations = [];
  bool _hasReachedMax = false;
  final ScrollController _scrollController2 = ScrollController();
  List<Class> _classes = [];
  bool _hasReachedMax2 = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    TabBar tabBar = TabBar(
      indicatorColor: Colors.indigo,
      labelStyle: poppinsTheme.caption,
      tabs: [
        Tab(
          icon: const Icon(Icons.people_alt_rounded, size: 20),
          text: tr("consultation"),
        ),
        Tab(
          icon: const Icon(Icons.class__rounded, size: 20),
          text: tr("class"),
        ),
      ]
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('reviews').tr(),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(tabBar.preferredSize.height),
            child: tabBar,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TabBarView(
            children: [
              _consultationTab(_provider.user!.expertId!),
              _classTab(_provider.user!.expertId!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _consultationTab(String expertId) {
    return FutureBuilder<List<Consultation>>(
      future: Consultation.getReviews(expertId, _consultations.length, 20),
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
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return (index < _consultations.length)
                  ? ConsultationReviewCard(consultation: _consultations[index])
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
    );
  }

  Widget _classTab(String expertId) {
    return FutureBuilder<List<Class>>(
      future: Class.getReviews(expertId, _classes.length, 20),
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
              _hasReachedMax2 = true;
              data = [];
              setState(() {});
            });
          }
  
          _scrollController2.addListener(() {
            double currentScroll = _scrollController2.position.pixels;
            double maxScroll = _scrollController2.position.maxScrollExtent;
  
            if (currentScroll == maxScroll) {
              if (!_hasReachedMax2) {
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
              controller: _scrollController2,
              itemBuilder: (context, index) {
                return (index < _classes.length)
                  ? ClassReviewCard(classModel: _classes[index])
                  : const Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    );
              },
              itemCount: _hasReachedMax2 ? _classes.length : _classes.length + 1,
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
    );
  }
}