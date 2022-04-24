import 'package:flexone/common/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class UserListTile extends StatelessWidget {
  String? image;
  String? id;
  String? name;
  String? email;
  Widget? trailing;

  UserListTile({Key? key, this.image, this.id, this.name, this.email, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
          Text(
            email!,
            style: poppinsTheme.caption,
          )
        ]
      ),
      trailing: trailing,
      onTap: () => Get.toNamed('/user/detail?id=$id'),
    );
  }
}
