import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/screens/class/class_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyClassCard extends StatelessWidget {
  Class classModel;
  Function()? onGiveRating;
  Function()? onViewReview;

  MyClassCard({ Key? key, required this.classModel, this.onGiveRating, this.onViewReview }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _tileColor = _preferencesProvider.isDarkTheme ? const Color(0xFF616161) : Colors.white;

    return InkWell(
      onTap: () {
        classModel.joined = true;
        Get.to(ClassDetailScreen(classModel: classModel));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(classModel.detail!.invoice, style: poppinsTheme.caption),
          const SizedBox(height: 15),
          Row(
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
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
                color: _tileColor,
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: (classModel.detail!.rating == 0) ? 
                      ListTile(
                        leading: const Icon(Icons.star),
                        title: const Text('give_rating').tr(),
                        tileColor: _tileColor,
                        dense: true,
                        onTap: onGiveRating,
                      )
                    :
                      ListTile(
                        leading: const Icon(Icons.star),
                        title: const Text('view_review').tr(),
                        tileColor: _tileColor,
                        dense: true,
                        onTap: onViewReview,
                      ),
                  ),
                ],
              ),
            ]
          ),
        ],
      ),
    );
  }
}