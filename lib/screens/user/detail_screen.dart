import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/expert_result.dart';
import 'package:flexone/data/models/user_result.dart';
import 'package:flexone/widgets/counter_container.dart';
import 'package:flexone/widgets/info_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          UserModel.getDetail(Get.parameters['id']!),
          Expert.getExpertByID("E${Get.parameters['id']}")
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                    title: Text(
                        "${snapshot.data![0].fullname!}#${snapshot.data![0].userId}",
                        style: poppinsTheme.bodyText1)),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (snapshot.data![0].photo != null &&
                                snapshot.data![0].photo != "")
                            ? Center(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data![0].photo!),
                                          fit: BoxFit.cover)),
                                ),
                              )
                            : Center(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/profile-icon.png'),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                        const SizedBox(height: 5),
                        Center(
                          child: Text(snapshot.data![0].fullname!,
                              style: poppinsTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 5),
                        Center(child: Text(snapshot.data![0].email!)),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CounterContainer(
                              value: snapshot.data![0].followers!,
                              title: 'followers',
                            ),
                            const SizedBox(width: 15),
                            CounterContainer(
                              value: snapshot.data![0].following!,
                              title: 'following',
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CounterContainer(
                              value: snapshot.data![0].questions!,
                              title: 'questions_asked',
                            ),
                            const SizedBox(width: 15),
                            CounterContainer(
                              value: snapshot.data![0].answers!,
                              title: 'answers_given',
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          'about',
                          style: poppinsTheme.headline6,
                        ).tr(),
                        const SizedBox(height: 5),
                        Text(
                          snapshot.data![0].about ?? "-",
                          style: poppinsTheme.bodyText2,
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            tr("joined") +
                                " " +
                                DateFormat('d MMMM y').format(DateTime.parse(
                                    snapshot.data![0].createdAt!)),
                            style: poppinsTheme.caption!
                                .copyWith(color: Colors.grey[700]),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          'additional_info',
                          style: poppinsTheme.headline6,
                        ).tr(),
                        const SizedBox(height: 10),
                        InfoRow(
                            value: snapshot.data![1] == null
                                ? "-"
                                : snapshot.data![1].education,
                            label: "education",
                            icon: Icons.school_rounded),
                        const SizedBox(height: 10),
                        InfoRow(
                            value: snapshot.data![1] == null
                                ? "-"
                                : snapshot.data![1].job,
                            label: "job",
                            icon: Icons.work_rounded),
                        const SizedBox(height: 5),
                        InfoRow(
                            value: snapshot.data![0].phone ?? "-",
                            label: "phone_number",
                            icon: Icons.phone),
                        const SizedBox(height: 10),
                        InfoRow(
                            value: snapshot.data![0].city ?? "-",
                            label: "city",
                            icon: Icons.location_city_rounded),
                      ],
                    ),
                  ),
                ));
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(snapshot.error.toString()),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
        });
  }
}
