import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/providers/certificates.dart';
import 'package:flexone/data/providers/email_sign_in.dart';
import 'package:flexone/data/providers/google_sign_in.dart';
import 'package:flexone/data/providers/module.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/question.dart';
import 'package:flexone/data/providers/room.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/auth/register_screen.dart';
import 'package:flexone/screens/auth/login_screen.dart';
import 'package:flexone/screens/cart_screen.dart';
import 'package:flexone/screens/class/add_class_screen.dart';
import 'package:flexone/screens/class/my_class_screen.dart';
import 'package:flexone/screens/consultation/add_consultation_screen.dart';
import 'package:flexone/screens/consultation/my_consultation_screen.dart';
import 'package:flexone/screens/consultation/request/request_screen.dart';
import 'package:flexone/screens/discussion/add_question_screen.dart';
import 'package:flexone/screens/expert/add_certificate_screen.dart';
import 'package:flexone/screens/expert/add_skill_screen.dart';
import 'package:flexone/screens/expert/certificate_screen.dart';
import 'package:flexone/screens/expert/expert_profile_screen.dart';
import 'package:flexone/screens/expert/new_account_screen.dart';
import 'package:flexone/screens/main_screen.dart';
import 'package:flexone/screens/merchandise/history_screen.dart';
import 'package:flexone/screens/merchandise/shop_screen.dart';
import 'package:flexone/screens/discussion/question_screen.dart';
import 'package:flexone/screens/room/add_room_screen.dart';
import 'package:flexone/screens/room/my_room_screen.dart';
import 'package:flexone/screens/settings_screen.dart';
import 'package:flexone/screens/user/activity_log_screen.dart';
import 'package:flexone/screens/user/detail_screen.dart';
import 'package:flexone/screens/user/list_chat_screen.dart';
import 'package:flexone/screens/user/profile_screen.dart';
import 'package:flexone/screens/user/report_screen.dart';
import 'package:flexone/screens/user/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('id'), Locale('en', 'US')],
      path: 'assets/translations',
      startLocale: const Locale('id'),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
        ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (_) => EmailSignInProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CertificateProvider()),
        ChangeNotifierProvider(create: (_) => QuestionProvider()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => ModuleProvider()),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, _) {
          return GetMaterialApp(
              initialRoute: '/',
              getPages: [
                GetPage(name: '/', page: () => const MainScreen()),
                GetPage(name: '/login', page: () => const LoginScreen()),
                GetPage(name: '/register', page: () => const RegisterScreen()),
                GetPage(name: '/settings', page: () => const SettingsScreen()),
                GetPage(name: '/profile', page: () => const ProfileScreen()),
                GetPage(name: '/activity_log', page: () => const ActivityLogScreen()),
                GetPage(name: '/user', page: () => const UserScreen()),
                GetPage(name: '/user/detail', page: () => const UserDetailScreen()),
                GetPage(name: '/report', page: () => const ReportScreen()),
                GetPage(name: '/expert/new', page: () => const NewAccountScreen()),
                GetPage(name: '/expert/profile', page: () => const ExpertProfileScreen()),
                GetPage(name: '/add_skill', page: () => const AddSkillScreen()),
                GetPage(name: '/certificate', page: () => const CertificateScreen()),
                GetPage(name: '/add_certificate', page: () => const AddCertificateScreen()),
                GetPage(name: '/list_chat', page: () => const ListChatScreen()),
                GetPage(name: '/shop', page: () => const ShopScreen()),
                GetPage(name: '/merchandise-history', page: () => const MerchandiseHistoryScreen()),
                GetPage(name: '/question', page: () => const QuestionScreen()),
                GetPage(name: '/add_question', page: () => const AddQuestionScreen()),
                GetPage(name: '/my_rooms', page: () => const MyRoomScreen()),
                GetPage(name: '/add_room', page: () => const AddRoomScreen()),
                GetPage(name: '/add_consultation', page: () => const AddConsultationScreen()),
                GetPage(name: '/request', page: () => const RequestScreen()),
                GetPage(name: '/my_consultations', page: () => const MyConsultationScreen()),
                GetPage(name: '/cart', page: () => const CartScreen()),
                GetPage(name: '/add_class', page: () => const AddClassScreen()),
                GetPage(name: '/my_classes', page: () => const MyClassScreen()),
              ],
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              title: 'Flexone',
              theme: provider.isDarkTheme ? darkTheme : lightTheme,
              home: const MainScreen());
        },
      ),
    );
  }
}
