import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/merchandise_result.dart';
import 'package:flexone/screens/merchandise/detail_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MerchandiseCard extends StatelessWidget {
  Merchandise merchandise;
  Function() onPressed;

  MerchandiseCard({ Key? key, required this.merchandise, required this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () => Get.to(MerchandiseDetailScreen(merchandise: merchandise)),
            child: (merchandise.photo != null && merchandise.photo != "") ? Image.network(merchandise.photo!, fit: BoxFit.cover) : Image.asset('assets/images/photo-icon.png', fit: BoxFit.contain),
          ),
          footer: SizedBox(
            height: 100,
            child: GridTileBar(
                backgroundColor: Colors.black87,
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        merchandise.name, 
                        overflow: TextOverflow.ellipsis, 
                        style: poppinsTheme.bodyText2
                      ),
                      Text(
                        tr("points", args: [convertToDecimalPattern(context.locale == const Locale('id') ? 'id' : 'en_US', merchandise.price)]), 
                        overflow: TextOverflow.ellipsis, 
                        style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold)
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          child: IgnorePointer(
                            ignoring: merchandise.stock == 0,
                            child: ElevatedButton(
                              onPressed: onPressed,
                              style: ElevatedButton.styleFrom(primary: merchandise.stock == 0 ? Colors.grey : Colors.indigo),
                              child: const Text('buy').tr()
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),
          ),
      ),
    );
  }
}