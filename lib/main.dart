import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/providers/email_sign_in.dart';
import 'package:flexone/data/providers/google_sign_in.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/screens/auth/register_screen.dart';
import 'package:flexone/screens/auth/login_screen.dart';
import 'package:flexone/screens/main_screen.dart';
import 'package:flexone/screens/settings_screen.dart';
import 'package:flexone/screens/user/activity_log_screen.dart';
import 'package:flexone/screens/user/detail_screen.dart';
import 'package:flexone/screens/user/profile_screen.dart';
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
                GetPage(name: '/user/detail', page: () => const UserDetailScreen())
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
