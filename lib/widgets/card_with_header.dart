import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flutter/material.dart';

class CardWithHeader extends StatelessWidget {
  Widget content;
  String headerText;

  CardWithHeader({Key? key, required this.headerText, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            height: 50,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  headerText,
                  style: poppinsTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ).tr()),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: content)
        ],
      ),
    );
  }
}
