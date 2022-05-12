import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/screens/consultation/consultation_detail_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RequestCard extends StatelessWidget {
  ConsultationRequest request;
  Function()? onRejected;
  Function()? onAccepted;
  Function()? onRescheduled;

  RequestCard({ Key? key, required this.request, this.onRejected, this.onAccepted, this.onRescheduled }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("created_at", style: poppinsTheme.caption).tr(),
            const SizedBox(width: 10),
            Text(convertToDateFormat('dd/MM/y HH:mm', request.requestedAt), style: poppinsTheme.caption),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
          GestureDetector(
            onTap: () => Get.toNamed('/user/detail?id=${request.user.id}'),
            child: (request.user.photo != null && request.user.photo != "") ? 
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    image: DecorationImage(
                      image: NetworkImage(request.user.photo!), 
                      fit: BoxFit.cover
                    )
                  ),
                )
              : 
                Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile-icon.png'),
                      fit: BoxFit.cover
                    )
                  ),
                ),
          ),
          const SizedBox(width: 10),
          Text('${request.user.name} #${request.user.id}')
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 45),
          child: Column(
            children: [
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.calendarDay, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    convertToDateFormat('dd/MM/y HH:mm', request.appointmentDate),
                    style: poppinsTheme.caption!.copyWith(fontSize: 11),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.clock, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    tr("minutes_wp", args: [request.duration.toString()]),
                    style: poppinsTheme.caption!.copyWith(fontSize: 11),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.noteSticky, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    request.explanation,
                    style: poppinsTheme.caption!.copyWith(fontSize: 11),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Consultation consultation = await Consultation.getConsultation(request.consultation.id);
                      Get.to(ConsultationDetailScreen(consultation: consultation));
                    },
                    child: (request.consultation.photo != null && request.consultation.photo != "")
                    ? Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          image: DecorationImage(
                            image: NetworkImage(request.consultation.photo), 
                            fit: BoxFit.cover
                          )
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
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
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 125,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text(request.consultation.name, style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 5),
                        if (request.consultation.discountPrice > 0) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Row(
                              children: [
                                Text(
                                  convertToRupiah(request.consultation.price),
                                  style: poppinsTheme.caption!.copyWith(
                                    fontSize: 11,
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
                                    getDiscount(request.consultation.price, request.consultation.discountPrice),
                                    style: poppinsTheme.caption!.copyWith(
                                      fontSize: 11,
                                      color: Colors.white
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(
                              convertToRupiah(request.consultation.discountPrice),
                              style: poppinsTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        ]
                        else ...[
                          Text(
                            convertToRupiah(request.consultation.price), 
                            style: poppinsTheme.caption!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                  )
                ]
              ),        
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (onRejected != null) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRejected, 
                  icon: const FaIcon(FontAwesomeIcons.xmark), 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                  label: const Text('reject').tr()
                ),
              ),
              const SizedBox(width: 5),
            ],
            if (onAccepted != null) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAccepted, 
                  icon: const FaIcon(FontAwesomeIcons.check), 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  label: const Text('accept').tr()
                ),
              ),
            ],
            if (onRescheduled != null) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRescheduled, 
                  icon: const Icon(Icons.edit, color: Colors.white), 
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(primaryColor)),
                  label: const Text('reschedule', style: TextStyle(color: Colors.white)).tr()
                ),
              ),
            ],
            if (request.reason != "" && request.reason != null) ...[
              Text('reason:', style: poppinsTheme.bodyText2!.copyWith(fontSize: 13, fontWeight: FontWeight.bold)).tr(),
              const SizedBox(width: 10),
              Expanded(child: Text(request.reason!, style: poppinsTheme.caption)) 
            ]
          ],
        ),
      ],
    );
  }
}