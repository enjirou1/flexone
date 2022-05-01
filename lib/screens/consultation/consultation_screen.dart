import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/screens/consultation/filter_screen.dart';
import 'package:flexone/widgets/card/consultation_card.dart';
import 'package:flexone/widgets/edittext/search_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({ Key? key }) : super(key: key);

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Consultation> _consultations = [];
  String _keywords = "";
  int? _lowest = null, _highest = null, _rating = null;
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
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
              _consultations.clear();
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
              _consultations.clear();
              _hasReachedMax = false;

              setState(() {});
            },
            onPressed: () async {
              final result = await Get.to(const FilterScreen());
              if (result != null) {
                _lowest = result['lowest'] == null ? null : int.parse(result['lowest']);
                _highest = result['highest'] == null ? null : int.parse(result['highest']);
                _rating = result['rating'] == null ? null : int.parse(result['rating']);
                _consultations.clear();
                setState(() {});
              }
            }
          ),
          Expanded(
            child: FutureBuilder<List<Consultation>>(
              future: Consultation.getConsultations(_consultations.length, 20, _keywords, _rating, _lowest, _highest),
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
                          ? ConsultationCard(consultation: _consultations[index])
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
            ),
          )
        ],
      ),
    );
  }
}