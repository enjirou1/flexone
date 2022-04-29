import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/screens/consultation/consultation_detail_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ConsultationReviewCard extends StatelessWidget {
  Consultation consultation;

  ConsultationReviewCard({ Key? key, required this.consultation }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _tileColor = _preferencesProvider.isDarkTheme ? const Color(0xFF616161) : Colors.white;
    
    return InkWell(
      onTap: () => Get.to(ConsultationDetailScreen(consultation: consultation)),
      child: Column(
        children: [
          if (consultation.detail!.status == "paid") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(consultation.detail!.invoice!, style: poppinsTheme.caption),
                Text(convertToDateFormat('dd/MM/y', consultation.detail!.joinedAt), style: poppinsTheme.caption)
              ],
            ),
            const SizedBox(height: 15)
          ],
          InkWell(
            onTap: () => Get.toNamed('/user/detail?id=${consultation.user!.id}'),
            child: Row(
              children: [
                (consultation.user!.photo != null && consultation.user!.photo != "")
                ? Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      image: DecorationImage(
                        image: NetworkImage(consultation.user!.photo!), 
                        fit: BoxFit.cover
                      )
                    ),
                  )
                : Container(
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
                const SizedBox(width: 10),
                Text("${consultation.user!.name} #${consultation.user!.id}"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: consultation.detail!.rating.toDouble(),
                      unratedColor: Colors.grey,
                      itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 18,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 5),
                    Text(consultation.detail!.rating.toString(), style: poppinsTheme.caption!.copyWith(fontSize: 15, color: Colors.amber)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  consultation.detail!.review! == "" ? "-" : consultation.detail!.review!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: poppinsTheme.subtitle2,
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (consultation.photo != null && consultation.photo != "")
                    ? Container(
                        width: 50,
                        height: 50,
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(consultation.name, style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 10),
                          if (consultation.discountPrice > 0) ...[
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Row(
                                children: [
                                  Text(
                                    convertToRupiah(consultation.price),
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
                                      getDiscount(consultation.price, consultation.discountPrice),
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
                                convertToRupiah(consultation.discountPrice),
                                style: poppinsTheme.bodyText2!.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            )
                          ]
                          else ...[
                            Text(
                              convertToRupiah(consultation.price), 
                              style: poppinsTheme.bodyText2!.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ]
                ),
              ],
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}