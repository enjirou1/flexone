import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flutter/material.dart';

class CounterContainer extends StatelessWidget {
  final int value;
  final String title;

  const CounterContainer({Key? key, required this.value, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String compactValue = NumberFormat.compact(
            locale: context.locale == const Locale('id') ? 'id' : 'en_US')
        .format(value);
    return Container(
      width: 150,
      height: 75,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.indigo[200]),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              compactValue,
              style:
                  poppinsTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: poppinsTheme.caption!.copyWith(fontSize: 10),
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
            ).tr()
          ],
        ),
      ),
    );
  }
}
