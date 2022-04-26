import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/screens/class/class_detail_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassItemCard extends StatelessWidget {
  Class classModel;
  Function() onRemoved;

  ClassItemCard({ Key? key, required this.classModel, required this.onRemoved }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(ClassDetailScreen(classModel: classModel)),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(classModel.name, style: poppinsTheme.caption!.copyWith(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(classModel.expert!.name, style: poppinsTheme.caption!.copyWith(fontSize: 11)),
                ),
                const SizedBox(height: 5),
                if (classModel.discountPrice > 0) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Row(
                      children: [
                        Text(
                          convertToRupiah(classModel.price),
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
                            getDiscount(classModel.price, classModel.discountPrice),
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
                      convertToRupiah(classModel.discountPrice),
                      style: poppinsTheme.bodyText1!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  )
                ]
                else ...[
                  Text(
                    convertToRupiah(classModel.price), 
                    style: poppinsTheme.bodyText1!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
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