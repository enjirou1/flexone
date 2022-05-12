import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/consultation/consultation_review_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ConsultationDetailScreen extends StatefulWidget {
  Consultation consultation;

  ConsultationDetailScreen({ Key? key, required this.consultation }) : super(key: key);

  @override
  State<ConsultationDetailScreen> createState() => _ConsultationDetailScreenState();
}

class _ConsultationDetailScreenState extends State<ConsultationDetailScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    final _preferenceProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _datePickerBgColor = _preferenceProvider.isDarkTheme ? const Color(0xFF616161) : Colors.white;
    final Color _datePickerItemColor = _preferenceProvider.isDarkTheme ? Colors.white : primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.consultation.name, style: poppinsTheme.bodyText1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            (widget.consultation.photo != null && widget.consultation.photo != "")
              ? GestureDetector(
                  onTap: () => Get.to(PreviewImage(image: widget.consultation.photo)),
                  child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                          image: NetworkImage(widget.consultation.photo), 
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                )
              : Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/photo-icon.png'),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              const SizedBox(height: 10),
              Text(
                widget.consultation.name, 
                style: poppinsTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                widget.consultation.description, 
                style: poppinsTheme.bodyText1,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(tr('topic'))
                  ),
                  Expanded(
                    child: Text(
                      widget.consultation.topic, 
                      style: poppinsTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(tr('created_at'))
                  ),
                  Text(
                    convertToDateFormat('dd/MM/y', widget.consultation.createdAt), 
                    style: poppinsTheme.bodyText2,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 25,
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.people_alt_rounded, size: 20)
                  ),
                  const SizedBox(width: 5),
                  Text(widget.consultation.totalParticipants.toString())
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Get.to(ConsultationReviewScreen(consultationId: widget.consultation.id)),
                behavior: HitTestBehavior.translucent,
                child: Row(
                  children: [
                    RatingBarIndicator(
                      rating: widget.consultation.rating.toDouble(),
                      unratedColor: Colors.grey,
                      itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 5),
                    Text(widget.consultation.rating.toString(), style: poppinsTheme.caption!.copyWith(fontSize: 15, color: Colors.amber)),
                    const SizedBox(width: 5),
                    Text('(${widget.consultation.totalRatings})', style: poppinsTheme.caption!.copyWith(fontSize: 13)),
                    const SizedBox(width: 10),
                    const Icon(Icons.chevron_right_rounded)
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (widget.consultation.expert != null) ...[
                InkWell(
                  onTap: () => Get.toNamed('/user/detail?id=${widget.consultation.expert!.userId}'),
                  child: Row(
                    children: [
                      (widget.consultation.expert!.photo != null && widget.consultation.expert!.photo != "")
                      ? Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                            image: DecorationImage(
                              image: NetworkImage(widget.consultation.expert!.photo!), 
                              fit: BoxFit.cover
                            )
                          ),
                        )
                      : Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage('assets/images/profile-icon.png'),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                      const SizedBox(width: 5),
                      Text(widget.consultation.expert!.name),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 30),
              if (widget.consultation.discountPrice > 0) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Row(
                    children: [
                      Text(
                        convertToRupiah(widget.consultation.price),
                        style: poppinsTheme.bodyText1!.copyWith(
                          decoration: TextDecoration.lineThrough
                        )
                      ),
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.indigo
                        ),
                        child: Text(
                          getDiscount(widget.consultation.price, widget.consultation.discountPrice),
                          style: poppinsTheme.caption!.copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  )
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    convertToRupiah(widget.consultation.discountPrice),
                    style: poppinsTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
                  ),
                )
              ]
              else ...[
                Text(
                  convertToRupiah(widget.consultation.price),
                  style: poppinsTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 10),
              if (_provider.user == null) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed('/login'),
                    child: const Text('Login'),
                  ),
                )
              ],
              // widget.consultation.expertId is not null when getReviews is called
              if (_provider.user?.userId != widget.consultation.expert?.userId && _provider.user != null && widget.consultation.expertId == null) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          InputValidation inputValidation = InputValidation(isValid: true, message: '');
                          InputValidation durationValidation = InputValidation(isValid: true, message: '');
                          String selectedDate = "";
                          List<AppointmentDate> appointmentDates = [];

                          return StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                              actionsPadding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                              actions: [
                                TextField(
                                  controller: _controller,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    labelText: tr("notes"),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: secondaryColor)),
                                    labelStyle: TextStyle(color: secondaryColor),
                                    errorText: inputValidation.isValid ? null : inputValidation.message
                                  )
                                ),
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
                                        inputValidation = InputValidation(isValid: _controller.text.isNotEmpty, message: tr('error.notes.empty'));
                                        durationValidation = InputValidation(isValid: _durationController.text.isNotEmpty, message: tr('error.duration.empty'));
                                      });

                                      Consultation.checkAppointmentDate(
                                        widget.consultation.id, 
                                        selectedDate, 
                                        _durationController.text
                                      ).then((value) {
                                        appointmentDates = value;
                                        setState(() {});
                                        print(appointmentDates);
                                      });

                                      if (_controller.text.isNotEmpty && _durationController.text.isNotEmpty) {
                                        if (selectedDate != "") {
                                          final dates = await Consultation.checkAppointmentDate(
                                            widget.consultation.id, 
                                            selectedDate,
                                            _durationController.text
                                          );

                                          if (dates.isEmpty) {
                                            await Consultation.joinConsultation(
                                              widget.consultation.id, 
                                              _provider.user!.userId!, 
                                              selectedDate,
                                              _durationController.text,
                                              _controller.text
                                            );
                                            Navigator.pop(context);
                                            Get.snackbar(
                                              tr('success'), tr('success_detail.send_request'),
                                              snackPosition: SnackPosition.BOTTOM,
                                              animationDuration: const Duration(milliseconds: 300),
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              icon: const Icon(Icons.check, color: Colors.white),
                                              duration: const Duration(seconds: 2)
                                            );
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
                                    child: const Text("send_request").tr()
                                  ),
                                )
                              ],
                            )
                          );
                        }
                      );
                    }, 
                    child: Text('join', style: poppinsTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold)).tr() 
                  ),
                )
              ]
            ],
          )
        ),
      ),
    );
  }
}