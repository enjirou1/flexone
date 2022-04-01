import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('activity_logs').tr()),
      body: Container(),
    );
  }
}
