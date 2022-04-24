import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/screens/consultation/consultation_detail_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ConsultationCard extends StatelessWidget {
  Consultation consultation;
  String? status;
  Function()? onRemoved;
  Function()? onUpdated;

  ConsultationCard({ Key? key, required this.consultation, this.status, this.onRemoved, this.onUpdated }) : super(key: key);

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
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(consultation.name, style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(consultation.expert!.name, style: poppinsTheme.caption!.copyWith(fontSize: 11)),
                ),
                const SizedBox(height: 5),
                if (status != null && status != "1") ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      status == "0" ? "pending" : "declined", 
                      style: poppinsTheme.caption!.copyWith(
                        fontSize: 11, 
                        fontWeight: FontWeight.bold,
                        color: status == "0" ? Colors.amber : Colors.red
                      )
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: consultation.rating.toDouble(),
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
                    Text(consultation.rating.toString(), style: poppinsTheme.caption!.copyWith(fontSize: 15, color: Colors.amber)),
                    const SizedBox(width: 5),
                    Text('(${consultation.totalRatings})', style: poppinsTheme.caption!.copyWith(fontSize: 13))
                  ],
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
                const SizedBox(height: 5),
                Row(
                  children: [
                    if (onRemoved != null) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onRemoved, 
                          icon: const Icon(Icons.delete_rounded),
                          style: ElevatedButton.styleFrom(primary: Colors.red[800]),
                          label: Text('close', style: poppinsTheme.caption).tr()
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    if (onUpdated != null) ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onUpdated,
                          icon: const Icon(Icons.edit),
                          label: Text(
                            'edit',
                            style: poppinsTheme.caption
                          ).tr(),
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          )
        ]
      ),
    );
  }
}