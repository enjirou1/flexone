import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class BubbleRoomChat extends StatelessWidget {
  String? avatar;
  String name;
  String id;
  String? image;
  String? text;
  bool status;
  Timestamp date;

  BubbleRoomChat({ Key? key, this.avatar, required this.name, required this.id, this.image, this.text, required this.status, required this.date }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: status ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: status ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (status) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(name, style: poppinsTheme.caption),
              )
            ],
            (avatar != "" && avatar != null) ? 
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(avatar!), 
                    fit: BoxFit.cover
                  )
                ),
              )
            : 
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile-icon.png'),
                    fit: BoxFit.contain
                  )
                ),
              ),
            if (!status) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(name, style: poppinsTheme.caption),
              )
            ]
          ],
        ),
        const SizedBox(height: 5),
        (image == null) ? 
          Padding(
            padding: status ? const EdgeInsets.only(right: 35) : const EdgeInsets.only(left: 35),
            child: Card(
              elevation: 3, 
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              color: status ? Colors.indigo : Colors.grey,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                child: SelectableText(
                  text!,
                  style: notoSansDisplayTheme.bodyText2,
                )
              )
            ),
          )
        :
          Padding(
            padding: status ? const EdgeInsets.only(right: 35) : const EdgeInsets.only(left: 35),
            child: GestureDetector(
              onTap: () => Get.to(PreviewImage(image: image!)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage(image!), 
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
          ),
        Padding(
          padding: status ? const EdgeInsets.only(right: 35) : const EdgeInsets.only(left: 35),
          child: Text(
            timeago.format(date.toDate(), locale: 'en'),
            style: notoSansDisplayTheme.caption!.copyWith(fontSize: 10)
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}