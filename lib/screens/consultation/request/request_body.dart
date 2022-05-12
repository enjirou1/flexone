import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/utils/format.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flexone/widgets/card/request_card.dart';
import 'package:flexone/widgets/dialog/single_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class RequestBody extends StatefulWidget {
  int status;

  RequestBody({ Key? key, required this.status }) : super(key: key);

  @override
  State<RequestBody> createState() => _RequestBodyState();
}

class _RequestBodyState extends State<RequestBody> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _durationController = TextEditingController();
  List<ConsultationRequest> _requests = [];
  bool _hasReachedMax = false;

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final _preferenceProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _datePickerBgColor = _preferenceProvider.isDarkTheme ? const Color(0xFF616161) : Colors.white;
    final Color _datePickerItemColor = _preferenceProvider.isDarkTheme ? Colors.white : primaryColor;

    return FutureBuilder<List<ConsultationRequest>>(
      future: ConsultationRequest.getRequests(_provider.user!.expertId!, _requests.length, 20, widget.status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<ConsultationRequest> data = snapshot.data!;
  
          if (_requests.isEmpty) {
            Future.delayed(Duration.zero, () {
              _requests.addAll(data);
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
                List<ConsultationRequest> temp = [];
                temp.addAll(_requests);
                _requests.clear();
                _requests.addAll([...temp, ...data]);
                data.clear();
                setState(() {});
              }
            }
          });
        }
  
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return (index < _requests.length)
                  ? RequestCard(
                      request: _requests[index],
                      onRejected: 
                      (widget.status == 0) ? 
                        () async {
                          showDialog(
                            context: context, 
                            builder: (BuildContext context) {
                              InputValidation _validation = InputValidation(isValid: true, message: '');

                              return StatefulBuilder(
                                builder: (context, setState) => SingleInputDialog(
                                  title: tr('reject_request'), 
                                  label: tr('reason'), 
                                  buttonText: tr("reject"), 
                                  controller: _controller, 
                                  inputValidation: _validation, 
                                  inputType: TextInputType.text, 
                                  obsecureText: false, 
                                  onPressed: () async {
                                    setState(() {
                                      _validation = InputValidation(isValid: _controller.text.isNotEmpty, message: tr('error.reason.empty'));
                                    });

                                    if (_controller.text.isNotEmpty) {
                                      await Consultation.respondRequest(_requests[index].id, 2, _controller.text);
                                      Navigator.pop(context);
                                      _requests.clear();
                                      _hasReachedMax = false;
                                      this.setState(() {});
                                    }
                                  }
                                )
                              );
                            }
                          );
                        } : null,
                      onAccepted: 
                      (widget.status == 0) ?
                        () async {
                          await Consultation.respondRequest(_requests[index].id, 1, '');
                          _requests.clear();
                          _hasReachedMax = false;
                          setState(() {});
                        } : null,
                      onRescheduled: 
                      (widget.status == 3) ?
                        () async {
                          showDialog(
                            context: context, 
                            builder: (BuildContext context) {
                              InputValidation durationValidation = InputValidation(isValid: true, message: '');
                              String selectedDate = "";
                              List<AppointmentDate> appointmentDates = [];

                              return StatefulBuilder(
                                builder: (context, setState) => AlertDialog(
                                  insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  actionsPadding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedDate != "" ? convertToDateFormat('dd/MM/y HH:mm', selectedDate) : "-", 
                                          style: poppinsTheme.bodyText2!.copyWith(color: Colors.black)
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            DatePicker.showDateTimePicker(
                                              context, 
                                              showTitleActions: true,
                                              theme: DatePickerTheme(
                                                backgroundColor: _datePickerBgColor,
                                                itemStyle: TextStyle(
                                                  color: _datePickerItemColor
                                                ),
                                              ),
                                              onConfirm: (date) {
                                                setState(() {
                                                  final String result = date.toString().substring(0, 16);
                                                  selectedDate = result;
                                                });
                                              },
                                              minTime: DateTime.now(),
                                              currentTime: DateTime.now(),
                                              locale: context.locale == const Locale('id') ? LocaleType.id : LocaleType.en
                                            );
                                          },
                                          child: const Text('choose_date').tr()
                                        ),
                                      ],
                                    ),
                                    TextField(
                                      controller: _durationController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: tr("duration"),
                                        isDense: true,
                                        prefixIcon: const Icon(Icons.access_alarm_rounded, color: Colors.black),
                                        suffixText: tr("minutes"),
                                        suffixStyle: const TextStyle(color: Colors.black),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
                                        labelStyle: TextStyle(color: secondaryColor),
                                        errorText: durationValidation.isValid ? null : durationValidation.message
                                      )
                                    ),
                                    if (appointmentDates.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Center(
                                        child: Text('error.schedule.booked', style: poppinsTheme.subtitle2!.copyWith(color: Colors.black),).tr(),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: appointmentDates.map((date) => Text(
                                            '${convertToDateFormat('dd/MM/y HH:mm', date.dtStart)} - ${convertToDateFormat('dd/MM/y HH:mm', date.dtEnd)}', 
                                            style: poppinsTheme.caption!.copyWith(color: Colors.red[400])
                                          )).toList(),
                                        ),
                                      ),
                                    ],
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            durationValidation = InputValidation(isValid: _durationController.text.isNotEmpty, message: tr('error.duration.empty'));
                                          });

                                          Consultation.checkAppointmentDate(
                                            _requests[index].consultation.id, 
                                            selectedDate, 
                                            _durationController.text
                                          ).then((value) {
                                            appointmentDates = value;
                                            setState(() {});
                                            print(appointmentDates);
                                          });

                                          if (_durationController.text.isNotEmpty) {
                                            if (selectedDate != "") {
                                              final dates = await Consultation.checkAppointmentDate(
                                                _requests[index].consultation.id, 
                                                selectedDate,
                                                _durationController.text
                                              );

                                              if (dates.isEmpty) {
                                                await Consultation.reschedule(
                                                  _requests[index].id, 
                                                  selectedDate,
                                                  _durationController.text
                                                );
                                                Navigator.pop(context);
                                                Get.snackbar(
                                                  tr('success'), tr('success_detail.reschedule'),
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  animationDuration: const Duration(milliseconds: 300),
                                                  backgroundColor: Colors.green,
                                                  colorText: Colors.white,
                                                  icon: const Icon(Icons.check, color: Colors.white),
                                                  duration: const Duration(seconds: 1)
                                                );
                                                _requests.clear();
                                                _hasReachedMax = false;
                                                this.setState(() {});
                                              } else {
                                                Get.snackbar(tr('failed'), tr('error.schedule.booked'),
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  colorText: Colors.white,
                                                  backgroundColor: Colors.red,
                                                  animationDuration: const Duration(milliseconds: 300),
                                                  duration: const Duration(seconds: 2)
                                                );
                                              }
                                            } else {
                                              Get.snackbar(tr('failed'), tr('error.date.empty'),
                                                snackPosition: SnackPosition.BOTTOM,
                                                colorText: Colors.white,
                                                backgroundColor: Colors.red,
                                                animationDuration: const Duration(milliseconds: 300),
                                                duration: const Duration(seconds: 2)
                                              );
                                            }
                                          }
                                        },
                                        child: const Text("reschedule").tr()
                                      ),
                                    )
                                  ],
                                )
                              );
                            }
                          );
                      } : null
                    )
                  : const Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(),
                      ),
                    );
              },
              itemCount: (_hasReachedMax || _requests.isEmpty) ? _requests.length : _requests.length + 1,
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