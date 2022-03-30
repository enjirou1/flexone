import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/providers/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('settings').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<PreferencesProvider>(
          builder: (context, provider, _) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'dark_mode',
                    style: poppinsTheme.bodyText1,
                  ).tr(),
                  Switch.adaptive(
                      value: provider.isDarkTheme,
                      onChanged: (value) {
                        provider.setDarkTheme(value);
                      })
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'choose_language',
                    style: poppinsTheme.bodyText1,
                  ).tr(),
                  DropdownButton(
                      items: [
                        DropdownMenuItem(
                          child: const Text('indonesia').tr(),
                          value: 'id',
                        ),
                        DropdownMenuItem(
                          child: const Text('english').tr(),
                          value: 'en',
                        ),
                      ],
                      value: provider.language,
                      onChanged: (value) async {
                        late Locale _newLocale;
                        (value == 'id')
                            ? _newLocale = const Locale('id')
                            : _newLocale = const Locale('en', 'US');
                        context.setLocale(_newLocale);
                        Get.updateLocale(_newLocale);
                        provider.setLanguage(value.toString());
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
