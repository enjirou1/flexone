import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/transaction_result.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/data/providers/google_sign_in.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/class/class_screen.dart';
import 'package:flexone/screens/consultation/consultation_screen.dart';
import 'package:flexone/screens/discussion/discussion_screen.dart';
import 'package:flexone/screens/room/room_screen.dart';
import 'package:flexone/screens/user/account_screen.dart';
import 'package:flexone/utils/launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {'page': const DiscussionScreen(), 'title': 'discussion'},
      {'page': const ConsultationScreen(), 'title': 'consultation'},
      {'page': const ClassScreen(), 'title': 'class'},
      {'page': const RoomScreen(), 'title': 'room'},
      {'page': const AccountScreen(), 'title': 'account'}
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final User? _user = FirebaseAuth.instance.currentUser;
    final provider = Provider.of<UserProvider>(context, listen: false);
    print(_user);

    if (_user != null) {
      UserModel.checkUser(_user.email!).then((value) async {
        if (value == false) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: const Text('your_account_has_been_banned').tr(),
              content: const Text('contact_us_for_further_information').tr(),
              actions: [
                Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      await Launcher.launchWhatsapp();
                    }, 
                    icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green), 
                    label: const Text("contact_us").tr()
                  ),
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: () async {
                      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                      await provider.logout();
                      Get.offAllNamed('/');
                    },
                    icon: const Icon(Icons.login, color: Colors.red),
                    label: const Text('logout', style: TextStyle(color: Colors.red),).tr(),
                  ),
                )
              ],
            )
          );
        }
      });
      UserModel.getUserByEmail(_user.email).then((value) {
        provider.setUser(value!);
        Cart.getCart(value.userId!).then((value) {
          if (value != null) provider.setCartItems(value.classItems.length + value.consultationItems.length);
        });
      });
    } else {
      Future.delayed(Duration.zero, () {
        provider.logout();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title'].toString()).tr(),
        actions: [
          Badge(
            position: BadgePosition.topEnd(top: 7, end: 5),
            padding: const EdgeInsets.all(3),
            badgeContent: Consumer<UserProvider>(
              builder: (context, user, _) {
                return Text(user.cartItems.toString(), style: poppinsTheme.caption!.copyWith(fontSize: 10));
              },
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Color(0XFFD6D6D6),
              ),
              onPressed: () => Get.toNamed('/cart'),
            ),
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.question_answer_rounded),
              label: tr('discussion')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.people_rounded),
              label: tr('consultation')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.class__rounded), label: tr('class')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.meeting_room_rounded), label: tr('room')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person_rounded), label: tr('account')),
        ],
      ),
    );
  }
}
