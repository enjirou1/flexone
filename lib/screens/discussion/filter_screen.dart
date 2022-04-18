import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({ Key? key }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<Subject> _subjects = [];
  List<Grade> _grades = [];
  int _selectedSubject = 0, _selectedGrade = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.center,
          child: IconButton(
            onPressed: () => Get.back(result: null),
            icon: const FaIcon(FontAwesomeIcons.xmark)
          )
        ),
        title: const Text('Filter'),
        actions: [
          IconButton(
            onPressed: () async {
              Get.back(result: {
                "subject": _selectedSubject,
                "grade": _selectedGrade
              });
            },
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            )
          )
        ]
      ),
      body: FutureBuilder(
        future: Future.wait([
          Subject.getSubjects(),
          Grade.getGrades()
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (_subjects.isEmpty) {
            Future.delayed(Duration.zero, () {
              _subjects = snapshot.data![0];
              setState(() {});
            });
          }

          if (_grades.isEmpty) {
            Future.delayed(Duration.zero, () {
              _grades = snapshot.data![1];
              setState(() {});
            });
          }

          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("subject", style: poppinsTheme.headline6).tr(),
                    Wrap(
                      spacing: 10.0,
                      children: _subjects.map<Widget>((subject) => ChoiceChip(
                        elevation: 3,
                        label: Text(
                          subject.name, 
                          style: poppinsTheme.caption!.copyWith(fontSize: 10)
                        ),
                        selectedColor: Colors.indigo[300],
                        selected: _selectedSubject == subject.id,
                        onSelected: (value) {
                          setState(() {
                            _selectedSubject = subject.id;
                          });
                        },
                      )).toList()
                    ),
                    const SizedBox(height: 20),
                    Text("grade", style: poppinsTheme.headline6).tr(),
                    Wrap(
                      spacing: 10.0,
                      children: _grades.map<Widget>((grade) => ChoiceChip(
                        elevation: 3,
                        label: Text(
                          grade.name, 
                          style: poppinsTheme.caption!.copyWith(fontSize: 10)
                        ),
                        selectedColor: Colors.indigo[300],
                        selected: _selectedGrade == grade.id,
                        onSelected: (value) {
                          setState(() {
                            _selectedGrade = grade.id;
                          });
                        },
                      )).toList()
                    ),
                  ],
                )
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