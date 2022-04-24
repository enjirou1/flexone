import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/screens/consultation/request/request_body.dart';
import 'package:flutter/material.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TabBar tabBar = TabBar(
      indicatorColor: Colors.indigo,
      tabs: [
        Tab(
          text: tr("pending"),
        ),
        Tab(
          text: tr("accepted"),
        ),
        Tab(
          text: tr("rejected"),
        ),
        Tab(
          text: tr("paid"),
        )
      ]
    );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('consultation_requests').tr(),
          bottom: tabBar,
        ),
        body: TabBarView(
          children: [
            RequestBody(status: 0), // pending
            RequestBody(status: 1), // accepted
            RequestBody(status: 2), // rejected
            RequestBody(status: 3), // paid
          ],
        ),
      ),
    );
  }
}