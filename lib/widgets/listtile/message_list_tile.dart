import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/user/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MessageListTile extends StatelessWidget {
  String? image;
  String? id;
  String? name;
  String? text;

  MessageListTile({Key? key, this.image, this.id, this.name, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: (image != null && image != "")
        ? Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
              image: DecorationImage(
                image: NetworkImage(image!), 
                fit: BoxFit.cover
              )
            ),
          )
        : Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage('assets/images/profile-icon.png'),
              fit: BoxFit.cover
            )
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Text(
              '$name #$id',
              style: poppinsTheme.bodyText2!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              text!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: poppinsTheme.caption,
            )
          ]
        ),
        onTap: () async {
          final UserModel? user = await UserModel.getUserByID(id);
          final bool followed = await UserModel.checkFollow(_provider.user!.userId!, id!);
          Get.to(ChatScreen(receiver: user!, followed: followed));
        },
      ),
    );
  }
}
