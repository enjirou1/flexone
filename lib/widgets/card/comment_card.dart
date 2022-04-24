import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends StatelessWidget {
  Comment comment;

  CommentCard({ Key? key, required this.comment }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed('/user/detail?id=${comment.user.id}'),
          child: Row(
            children: [
              (comment.user.photo != null && comment.user.photo != "")
              ? Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    image: DecorationImage(
                      image: NetworkImage(comment.user.photo), 
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${comment.user.name} #${comment.user.id}', style: poppinsTheme.caption!.copyWith(fontWeight: FontWeight.bold)),
                  Text(timeago.format(DateTime.parse(comment.createdAt), locale: 'en'), style: poppinsTheme.caption!.copyWith(fontSize: 10))
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SelectableText(comment.text, style: poppinsTheme.bodyText2),
      ],
    );
  }
}