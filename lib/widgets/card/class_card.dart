import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/screens/class/class_detail_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ClassCard extends StatelessWidget {
  Class classModel;
  int? status;
  Function()? onRemoved;
  Function()? onUpdated;

  ClassCard({ Key? key, required this.classModel, this.status, this.onRemoved, this.onUpdated }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(ClassDetailScreen(classModel: classModel));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (classModel.photo != null && classModel.photo != "")
          ? Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                  image: NetworkImage(classModel.photo!), 
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
                  child: Text(classModel.name, style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(classModel.expert!.name, style: poppinsTheme.caption!.copyWith(fontSize: 11)),
                ),
                const SizedBox(height: 5),
                if (status != null && status != 1) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      status == 0 ? "pending" : "declined", 
                      style: poppinsTheme.caption!.copyWith(
                        fontSize: 11, 
                        fontWeight: FontWeight.bold,
                        color: status == 0 ? Colors.amber : Colors.red
                      )
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                Row(
                  children: [
                    const Icon(Icons.people, size: 15),
                    const SizedBox(width: 5),
                    Text(classModel.totalParticipants.toString(), style: poppinsTheme.caption),
                    const SizedBox(width: 15),
                    const FaIcon(FontAwesomeIcons.clock, size: 12),
                    const SizedBox(width: 5),
                    Text('hours_wp', style: poppinsTheme.caption).tr(args: [classModel.estimatedTime.toString()]),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: classModel.rating.toDouble(),
                      unratedColor: Colors.grey,
                      itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 15,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 5),
                    Text(classModel.rating.toString(), style: poppinsTheme.caption!.copyWith(fontSize: 13, color: Colors.amber)),
                    const SizedBox(width: 5),
                    Text('(${classModel.totalRatings})', style: poppinsTheme.caption!.copyWith(fontSize: 12))
                  ],
                ),
                const SizedBox(height: 5),
                if (classModel.discountPrice > 0) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Row(
                      children: [
                        Text(
                          convertToRupiah(classModel.price),
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
                            getDiscount(classModel.price, classModel.discountPrice),
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
                      convertToRupiah(classModel.discountPrice),
                      style: poppinsTheme.bodyText2!.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                ]
                else ...[
                  Text(
                    convertToRupiah(classModel.price), 
                    style: poppinsTheme.bodyText2!.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
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
                          label: Text('delete', style: poppinsTheme.caption).tr()
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