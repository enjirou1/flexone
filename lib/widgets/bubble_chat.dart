import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexone/common/style.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class BubbleChat extends StatelessWidget {
  String text;
  bool status;
  Timestamp date;

  BubbleChat({ Key? key, required this.text, required this.status, required this.date }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: status ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 3, 
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          color: status ? Colors.indigo : Colors.grey,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
            child: SelectableText(
              text,
              style: notoSansDisplayTheme.bodyText2,
            ),
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            timeago.format(date.toDate(), locale: 'en'),
            style: notoSansDisplayTheme.caption!.copyWith(fontSize: 10)
          ),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}