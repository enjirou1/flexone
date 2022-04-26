import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/data/models/expert_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/consultation/edit_consultation_screen.dart';
import 'package:flexone/widgets/card/consultation_card.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flexone/widgets/edittext/search_edit_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ConsultationOwnedScreen extends StatefulWidget {
  Expert expert;

  ConsultationOwnedScreen({ Key? key, required this.expert }) : super(key: key);

  @override
  State<ConsultationOwnedScreen> createState() => _ConsultationOwnedScreenState();
}

class _ConsultationOwnedScreenState extends State<ConsultationOwnedScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Consultation> _consultations = [];
  String _keywords = "";
  int? _lowest = null, _highest = null, _rating = null;
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('consultations_owned').tr(),
      ),
      body: Padding(
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
              }
            ),
            Expanded(
              child: FutureBuilder<List<Consultation>>(
                future: Consultation.getConsultationsOwned(widget.expert.expertId!, _consultations.length, 20, _keywords),
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
                            ? ConsultationCard(
                                consultation: _consultations[index],
                                status: _consultations[index].status,
                                onRemoved: () {
                                  showDialog(
                                    context: context, 
                                    builder: (context) => ConfirmationDialog(
                                      title: 'confirmation.close_consultation.title',
                                      content: 'confirmation.close_consultation.content',
                                      buttonText: 'delete', 
                                      onCancel: () {
                                        Navigator.pop(context);
                                      }, 
                                      onPressed: () async {
                                        try {
                                          await Consultation.deleteConsultation(_consultations[index].id);
                                          Navigator.pop(context);
                                          _consultations.clear();
                                          _hasReachedMax = false;
                                          setState(() {});
                                        } catch (e) {
                                          Get.snackbar(tr('failed'), e.toString(),
                                            snackPosition: SnackPosition.BOTTOM,
                                            colorText: Colors.white,
                                            backgroundColor: Colors.red,
                                            animationDuration: const Duration(milliseconds: 300),
                                            duration: const Duration(seconds: 2)
                                          );
                                        }
                                      }
                                    )
                                  );
                                },
                                onUpdated: () async {
                                  final result = await Get.to(EditConsultationScreen(consultation: _consultations[index]));
                                  if (result != null) {
                                    _consultations.clear();
                                    _hasReachedMax = false;
                                    setState(() {});
                                    Get.snackbar(
                                      tr('success'), tr('success_detail.update_consultation'),
                                      snackPosition: SnackPosition.BOTTOM,
                                      animationDuration: const Duration(milliseconds: 300),
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      icon: const Icon(Icons.check, color: Colors.white),
                                      duration: const Duration(seconds: 1)
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
                        itemCount: _hasReachedMax ? _consultations.length : _consultations.length + 1,
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
          final result = await Get.toNamed('/add_consultation');
          if (result != null) {
            _consultations.clear();
            _hasReachedMax = false;
            setState(() {});
          }
        },
      ),
    );
  }
}