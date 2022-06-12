import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/data/models/expert_result.dart';
import 'package:flexone/data/providers/google_sign_in.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/utils/launcher.dart';
import 'package:flexone/widgets/card/profile_card.dart';
import 'package:flexone/widgets/dialog/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferencesProvider>(context, listen: true);
    final _provider = Provider.of<UserProvider>(context, listen: true);
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
            style: TextStyle(color: provider.isDarkTheme ? Colors.white : Colors.black),
          ).tr()
        ),
      ),
    ];

    final List<Widget> loggedinMenus = [
      const ProfileCard(),
      if (_provider.user?.expertId == null) ...[
         ListTile(
          leading: const Icon(Icons.account_box_rounded, color: Color(0XFFBDBDBD)),
          title: const Text('create_expert_account').tr(),
          onTap: () async {
            final expert = await Expert.getExpertByID('E${_provider.user?.userId}');
            if (expert == null) {
              final result = await Get.toNamed('/expert/new');

              if (result != null) {
                Get.snackbar(
                  tr('success'), tr('success_detail.create_expert'),
                  snackPosition: SnackPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  icon: const Icon(Icons.check, color: Colors.white),
                  duration: const Duration(seconds: 1)
                );
              }
            } else {
              Get.snackbar(
                tr('pending'), 'Permintaan akun expert anda sedang diverifikasi oleh admin',
                snackPosition: SnackPosition.BOTTOM,
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.amber,
                colorText: Colors.white,
                icon: const Icon(Icons.pending, color: Colors.white),
                duration: const Duration(seconds: 3)
              );
            }
          },
        )
      ]
      else ...[
        ListTile(
          leading: const Icon(Icons.account_box_rounded, color: Color(0XFFBDBDBD)),
          title: const Text('expert').tr(),
          onTap: () => Get.toNamed('/expert/profile'),
        ),
        ListTile(
          leading: const Icon(Icons.list_rounded, color: Color(0XFFBDBDBD)),
          title: const Text('consultation_requests').tr(),
          onTap: () => Get.toNamed('/request'),
        ),
      ],
      ListTile(
        leading: const Icon(Icons.search_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('search_user').tr(),
        onTap: () => Get.toNamed('/user'),
      ),
      ListTile(
        leading: const Icon(Icons.message_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('messages').tr(),
        onTap: () => Get.toNamed('/list_chat'),
      ),
      ListTile(
        leading: const Icon(Icons.question_answer_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('my_questions').tr(),
        onTap: () => Get.toNamed('/question'),
      ),
      ListTile(
        leading: const Icon(Icons.people_alt_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('my_consultations').tr(),
        onTap: () => Get.toNamed('/my_consultations'),
      ),
      ListTile(
        leading: const Icon(Icons.class__rounded, color: Color(0XFFBDBDBD)),
        title: const Text('my_classes').tr(),
        onTap: () => Get.toNamed('/my_classes'),
      ),
      ListTile(
        leading: const Icon(Icons.meeting_room_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('my_rooms').tr(),
        onTap: () => Get.toNamed('/my_rooms'),
      ),
      ListTile(
        leading: const Icon(Icons.shopping_bag_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('shop').tr(),
        onTap: () => Get.toNamed('/shop'),
      ),
      ListTile(
        leading: const Icon(Icons.access_time_filled_rounded, color: Color(0XFFBDBDBD)),
        title: const Text('activity_logs').tr(),
        onTap: () => Get.toNamed('/activity_log'),
      ),
      ListTile(
        leading: const Icon(Icons.settings, color: Color(0XFFBDBDBD)),
        title: const Text('settings').tr(),
        onTap: () => Get.toNamed('/settings'),
      ),
      ListTile(
        leading: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
        title: const Text('help').tr(),
        onTap: () async {
          await Launcher.launchWhatsapp();
        },
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
          showDialog(
            context: context, 
            builder: (context) => ConfirmationDialog(
              title: "confirmation.logout.title", 
              buttonText: "logout", 
              onCancel: () {
                Navigator.pop(context);
              }, 
              onPressed: () async {
                final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                await provider.logout();
                Get.offAllNamed('/');
              }
            )
          );
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView(children: _user != null ? loggedinMenus : menus),
    );
  }
}
