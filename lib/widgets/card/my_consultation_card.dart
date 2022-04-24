import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/consultation_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/screens/consultation/consultation_detail_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyConsultationCard extends StatelessWidget {
  Consultation consultation;
  String? status;
  Function()? onViewDetail;
  Function()? onGiveRating;
  Function()? onViewReview;
  Map<String, dynamic> statusColor = {
    "pending": Colors.amber,
    "rejected": Colors.red,
    "accepted": Colors.grey,
    "paid": Colors.green
  };

  MyConsultationCard({ Key? key, required this.consultation, this.status, this.onViewDetail, this.onGiveRating, this.onViewReview }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _fontColor = _preferencesProvider.isDarkTheme ? Colors.white : secondaryColor;
    final Color _tileColor = _preferencesProvider.isDarkTheme ? const Color(0xFF616161) : Colors.white;

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
                const SizedBox(height: 10),
                Text(
                  tr(consultation.detail!.status),
                  style: poppinsTheme.caption!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor[consultation.detail!.status]
                  ),
                )
              ],
            ),
          ),
          if (consultation.detail!.status != "pending" && consultation.detail!.status != "accepted") ...[
            PopupMenuButton(
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
              color: _tileColor,
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                if (consultation.detail!.status == "paid") ...[
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: (consultation.detail!.rating == 0) ? 
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
                if (consultation.detail!.status == "rejected") ...[
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: const Icon(Icons.info_outline_rounded),
                      title: const Text('rejection_detail').tr(),
                      tileColor: _tileColor,
                      dense: true,
                      onTap: onViewDetail,
                    ),
                  ),
                ]
              ],
            ),
          ]
        ]
      ),
    );
  }
}