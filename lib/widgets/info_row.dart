import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  String value;
  String label;
  IconData icon;

  InfoRow(
      {Key? key, required this.value, required this.label, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                value == "" ? "-" : value,
                style: poppinsTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(label, style: poppinsTheme.caption).tr(),
            ],
          ),
        ),
      ],
    );
  }
}
