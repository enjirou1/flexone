import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/screens/class/class_detail_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ClassReviewCard extends StatelessWidget {
  Class classModel;

  ClassReviewCard({ Key? key, required this.classModel }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _tileColor = _preferencesProvider.isDarkTheme ? const Color(0xFF616161) : Colors.white;
    
    return InkWell(
      onTap: () => Get.to(ClassDetailScreen(classModel: classModel)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(classModel.detail!.invoice, style: poppinsTheme.caption),
              Text(convertToDateFormat('dd/MM/y', classModel.detail!.joinedAt), style: poppinsTheme.caption)
            ],
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => Get.toNamed('/user/detail?id=${classModel.user!.id}'),
            child: Row(
              children: [
                (classModel.user!.photo != null && classModel.user!.photo != "")
                ? Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      image: DecorationImage(
                        image: NetworkImage(classModel.user!.photo!), 
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
                Text("${classModel.user!.name} #${classModel.user!.id}"),
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
                      rating: classModel.detail!.rating.toDouble(),
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
                    Text(classModel.detail!.rating.toString(), style: poppinsTheme.caption!.copyWith(fontSize: 15, color: Colors.amber)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  classModel.detail!.review! == "" ? "-" : classModel.detail!.review!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: poppinsTheme.subtitle2,
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (classModel.photo != null && classModel.photo != "")
                    ? Container(
                        width: 50,
                        height: 50,
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
                            child: Text(classModel.name, style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 10),
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