import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser;
    final _provider = Provider.of<UserProvider>(context, listen: true);
    String? _imagePath = _provider.user!.photo ?? _user!.photoURL;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Get.toNamed('/user/detail?id=${_provider.user!.userId}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (_imagePath != null && _imagePath != "")
                    ? Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black),
                            image: DecorationImage(
                                image: NetworkImage(_imagePath),
                                fit: BoxFit.cover)),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/profile-icon.png'),
                                fit: BoxFit.cover)),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _provider.user!.fullname!,
                        style: poppinsTheme.bodyText1
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _provider.user!.email!,
                        style: poppinsTheme.caption,
                      ),
                      Text(
                        '${_provider.user!.point} points',
                        style: poppinsTheme.caption,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Get.toNamed('/profile');
                    },
                    icon: const Icon(Icons.edit)))
          ],
        ),
      ),
    );
  }
}
