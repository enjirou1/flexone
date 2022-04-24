import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/screens/consultation/consultation_detail_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ConsultationItemCard extends StatelessWidget {
  Consultation consultation;
  Function() onRemoved;

  ConsultationItemCard({ Key? key, required this.consultation, required this.onRemoved }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(ConsultationDetailScreen(consultation: consultation)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (consultation.photo != null && consultation.photo != "")
          ? Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                  image: NetworkImage(consultation.photo), 
                  fit: BoxFit.cover
                )
              ),
            )
          : Container(
              width: 70,
              height: 70,
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(consultation.name, style: poppinsTheme.caption!.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(consultation.expert!.name, style: poppinsTheme.caption!.copyWith(fontSize: 11)),
                ),
                const SizedBox(height: 5),
                if (consultation.discountPrice > 0) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Row(
                      children: [
                        Text(
                          convertToRupiah(consultation.price),
                          style: poppinsTheme.bodyText2!.copyWith(
                            fontSize: 12,
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
                            getDiscount(consultation.price, consultation.discountPrice),
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
                      convertToRupiah(consultation.discountPrice),
                      style: poppinsTheme.bodyText1!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  )
                ]
                else ...[
                  Text(
                    convertToRupiah(consultation.price), 
                    style: poppinsTheme.bodyText1!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.calendarDay, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      convertToDateFormat('dd/MM/y hh:mm', consultation.detail!.appointmentDate),
                      style: poppinsTheme.caption!.copyWith(fontSize: 11),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FaIcon(FontAwesomeIcons.noteSticky, size: 15),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        consultation.detail!.explanation,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: poppinsTheme.caption!.copyWith(fontSize: 11),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemoved, 
            icon: const Icon(Icons.delete, color: Colors.red)
          )
        ]
      ),
    );
  }
}