import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/providers/module.dart';
import 'package:flexone/screens/class/module_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SyllabusDetailScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  String classId;

  SyllabusDetailScreen({ Key? key, required this.classId }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<ModuleProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('syllabus').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<Class>(
          future: Class.getClass(classId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Future.delayed(Duration.zero, () {
                _provider.setModules();
              });
            }

            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.sections!.map((section) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(section.name, style: notoSansDisplayTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: section.modules!.map((module) {
                          Future.delayed(Duration.zero, () {
                            _provider.addModule(module);
                          });
                         
                          return ListTile(
                            title: Text(module.name, style: notoSansDisplayTheme.subtitle2),
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 30),
                            dense: true,
                            onTap: () {
                              Future.delayed(Duration.zero, () {
                                _provider.openModule(module.id);
                              });
                              
                              Get.to(ModuleScreen());
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20)
                    ],
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }
        ),
      )
    );
  }
}