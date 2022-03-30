import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser;
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: (_user!.photoURL != null ||
                            _provider.user!.photo != null)
                        ? Image.network(
                            _user.photoURL != null
                                ? _user.photoURL!
                                : _provider.user!.photo!,
                            height: 70,
                            width: 70,
                          )
                        : Image.asset(
                            'assets/images/profile-icon.png',
                            height: 70,
                            width: 70,
                          )),
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
