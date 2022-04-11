import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/skill_result.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AddSkillScreen extends StatefulWidget {
  const AddSkillScreen({ Key? key }) : super(key: key);

  @override
  State<AddSkillScreen> createState() => _AddSkillScreenState();
}

class _AddSkillScreenState extends State<AddSkillScreen> {
  List<Skill> _skills = [];
  List<int> _temp = [];

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () => Get.back(result: null),
            icon: const FaIcon(FontAwesomeIcons.xmark)
          )
        ),
        title: const Text('add_skill').tr(),
        actions: [
          IconButton(
            onPressed: () async {
              Get.back(result: _temp);
            },
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            )
          )
        ]
      ),
      body: FutureBuilder<List<Skill>>(
        future: Skill.getSkills(),
        builder: (context, snapshot) {
          if (_skills.isEmpty) {
            Future.delayed(Duration.zero, () {
              _skills = snapshot.data!;
              setState(() {});
            });
          }

          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 10.0,
                children: _skills.map<Widget>((skill) => FilterChip(
                  showCheckmark: true,
                  checkmarkColor: Colors.indigo[500],
                  elevation: 3,
                  label: Text(
                    skill.name, 
                    style: poppinsTheme.caption!.copyWith(fontSize: 10)
                  ),
                  selected: _temp.contains(skill.id),
                  onSelected: (value) {
                    if (value) {
                      _temp.add(skill.id);
                    } else {
                      _temp.removeWhere((element) => element == skill.id);
                    }
                    setState(() {});
                  },
                )).toList()
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        }
      ),
    );
  }
}