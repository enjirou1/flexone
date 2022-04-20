import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flexone/screens/discussion/question_detail_screen.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class QuestionCard extends StatelessWidget {
  Question question;
  String userId;
  Function()? onRemoved;

  QuestionCard({ Key? key, required this.question, required this.userId, this.onRemoved }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed('/user/detail?id=${question.user.id}'),
          child: Row(
            children: [
              (question.user.photo != null && question.user.photo != "")
              ? Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                      image: DecorationImage(
                          image: NetworkImage(question.user.photo), fit: BoxFit.cover)),
                )
              : Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/profile-icon.png'),
                          fit: BoxFit.cover)),
                ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(question.user.name, style: poppinsTheme.caption!.copyWith(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text(
                        '${question.subject.name} (${question.grade.name})', 
                        style: poppinsTheme.caption!.copyWith(fontSize: 10)
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '+${tr('points', args: [question.point.toString()])}', 
                        style: poppinsTheme.caption!.copyWith(fontSize: 10, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                ],
              )
            ]
          ),
        ),
        const SizedBox(height: 10),
        Text(
          question.text, 
          style: poppinsTheme.bodyText2,
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
        const SizedBox(height: 10),
        if (question.photo != null && question.photo != "") ...[
          InkWell(
            onTap: () => Get.to(PreviewImage(image: question.photo)),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                image: DecorationImage(
                  image: NetworkImage(question.photo), 
                  fit: BoxFit.cover
                )
              )
            ),
          ),
          const SizedBox(height: 10)
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onRemoved != null) ...[
              ElevatedButton.icon(
                onPressed: onRemoved, 
                icon: const Icon(Icons.delete_rounded),
                style: ElevatedButton.styleFrom(primary: Colors.red[800]),
                label: Text('remove', style: poppinsTheme.caption).tr()
              ),
              const SizedBox(width: 5),
            ],
            ElevatedButton(
              onPressed: () => Get.to(QuestionDetailScreen(question: question)), 
              child: Text(
                (question.user.id == userId) ? 'view_answer' : 'give_answer', 
                style: poppinsTheme.caption
              ).tr(),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            timeago.format(DateTime.parse(question.createdAt), locale: 'en'),
            style: poppinsTheme.caption,
          ),
        ),
      ],
    );
  }
}