import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(title: const Text('activity_logs').tr()),
        body: FutureBuilder<List<ActivityLog>>(
          future: UserModel.getLogs(_provider.user!.userId!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                      dense: true,
                      title: Text(
                          context.locale == const Locale('id')
                              ? snapshot.data![index].id!
                              : snapshot.data![index].en!,
                          style: poppinsTheme.caption!.copyWith(fontSize: 12)));
                },
                itemCount: snapshot.data!.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  snapshot.error.toString(),
                  style: poppinsTheme.caption!.copyWith(fontSize: 12),
                ),
              ));
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          },
        ));
  }
}
