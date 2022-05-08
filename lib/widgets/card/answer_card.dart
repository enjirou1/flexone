import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flexone/screens/discussion/comment_screen.dart';
import 'package:flexone/utils/format.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class AnswerCard extends StatelessWidget {
  Answer answer;
  Function()? onCheck;
  Function() onRatingPressed;

  AnswerCard({ Key? key, required this.answer, required this.onCheck, required this.onRatingPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed('/user/detail?id=${answer.user.id}'),
          child: Row(
            children: [
              (answer.user.photo != null && answer.user.photo != "")
              ? Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    image: DecorationImage(
                      image: NetworkImage(answer.user.photo), 
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
                  Text('${answer.user.name} #${answer.user.id}', style: poppinsTheme.caption!.copyWith(fontWeight: FontWeight.bold)),
                  Text(timeago.format(DateTime.parse(answer.createdAt), locale: 'en'), style: poppinsTheme.caption!.copyWith(fontSize: 10))
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SelectableText(answer.text, style: poppinsTheme.bodyText2),
        if (answer.photo != "") ...[
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () => Get.to(PreviewImage(image: answer.photo)),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(answer.photo), 
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (answer.accepted) ...[
              const Padding(
                padding: EdgeInsets.all(12),
                child: FaIcon(
                  FontAwesomeIcons.check,
                  color: Colors.green,
                  size: 25,
                ),
              ),
            ] else ...[
              if (onCheck != null) ...[
                IconButton(
                  onPressed: onCheck,
                  icon: const FaIcon(
                    FontAwesomeIcons.check,
                    size: 25,
                  ),
                )
              ]
            ],
            const SizedBox(width: 25),
            IconButton(
              onPressed: onRatingPressed, 
              icon: const Icon(
                Icons.star, 
                color: Colors.yellow,
                size: 20,
              ),
            ),
            Text(answer.rating.toString(), style: poppinsTheme.caption),
            const SizedBox(width: 25),
            SizedBox(
              width: 120,
              child: TextButton(
                onPressed: () => Get.to(CommentScreen(answer: answer)), 
                child: Text('${tr('comments')} (${getCompactNumber(context.locale == const Locale('id') ? 'id' : 'en_US', answer.totalComments)})', style: poppinsTheme.caption)
              ),
            ),
          ],
        )
      ],
    );
  }
}