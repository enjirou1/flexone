import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/data/providers/google_sign_in.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferencesProvider>(context, listen: true);
    final _user = FirebaseAuth.instance.currentUser;

    final List<Widget> menus = [
      ListTile(
        leading: const Icon(Icons.settings, color: Color(0XFFBDBDBD)),
        title: const Text('settings').tr(),
        onTap: () => Get.toNamed('/settings'),
      ),
      ListTile(
        title: OutlinedButton(
            onPressed: () {
              Get.toNamed('/login');
            },
            child: Text(
              'sign_in',
              style: TextStyle(
                  color: provider.isDarkTheme ? Colors.white : Colors.black),
            ).tr()),
        onTap: null,
      ),
    ];

    final List<Widget> loggedinMenus = [
      const ProfileCard(),
      ListTile(
        leading:
            const Icon(Icons.receipt_long_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('transactions').tr(),
        onTap: null,
      ),
      ListTile(
        leading: const Icon(Icons.search_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('search_user').tr(),
        onTap: () => Get.toNamed('/user'),
      ),
      ListTile(
        leading: const Icon(Icons.message_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('messages').tr(),
        onTap: null,
      ),
      ListTile(
        leading: const Icon(Icons.people_alt_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('my_consultations').tr(),
        onTap: null,
      ),
      ListTile(
        leading: const Icon(Icons.class__rounded, color: Color(0XFFBDBDBD)),
        title: const Text('my_classes').tr(),
        onTap: null,
      ),
      ListTile(
        leading:
            const Icon(Icons.meeting_room_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('my_rooms').tr(),
        onTap: null,
      ),
      ListTile(
        leading: const Icon(Icons.access_time_filled_rounded,
            color: Color(0XFFBDBDBD)),
        title: const Text('activity_logs').tr(),
        onTap: () => Get.toNamed('/activity_log'),
      ),
      ListTile(
        leading: const Icon(Icons.settings, color: Color(0XFFBDBDBD)),
        title: const Text('settings').tr(),
        onTap: () => Get.toNamed('/settings'),
      ),
      ListTile(
        leading: const Icon(
          Icons.logout_rounded,
          color: Colors.red,
        ),
        title: const Text(
          'logout',
          style: TextStyle(color: Colors.red),
        ).tr(),
        onTap: () {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.logout();
          Get.offAllNamed('/');
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView(children: _user != null ? loggedinMenus : menus),
    );
  }
}
