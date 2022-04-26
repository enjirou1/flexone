import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/dicussion_result.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({ Key? key }) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _lowestController = TextEditingController();
  final TextEditingController _highestController = TextEditingController();
  String rating = "0";
  List<Subject> _subjects = [];
  List<Grade> _grades = [];
  int _selectedSubject = 0, _selectedGrade = 0;

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _borderColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;
    const List rbItems = ["5", "4", "3", "2", "1", "0"];

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
            onPressed: () {
              Get.back(result: {
                "lowest": _lowestController.text.isEmpty ? null : _lowestController.text,
                "highest": _highestController.text.isEmpty ? null : _highestController.text,
                "rating": rating == "0" ? null : rating,
                "subject": _selectedSubject == 0 ? null : _selectedSubject,
                "grade": _selectedGrade == 0 ? null : _selectedGrade
              });
            },
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            )
          )
        ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
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
                return Column(
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
                    const SizedBox(height: 10),
                    Text('price', style: poppinsTheme.headline5).tr(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _lowestController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: tr("lowest_price"),
                              labelStyle: TextStyle(color: _borderColor),
                              isDense: true
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _highestController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: tr("highest_price"),
                              labelStyle: TextStyle(color: _borderColor),
                              isDense: true
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Rating', style: poppinsTheme.headline5).tr(),
                    const SizedBox(height: 10),
                    ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: rbItems.map((item) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Radio<String>(
                            activeColor: Colors.indigo,
                            value: item,
                            groupValue: rating,
                            onChanged: (String? value) {
                              setState(() {
                                rating = value!;
                              });
                            },
                          ),
                          title: (item == "0") ? const Text('all').tr() : const Text('rating_rb').tr(args: [item.toString()]),
                          dense: true,
                        );
                      }).toList()
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _selectedGrade = 0;
                          _selectedSubject = 0;
                          rating = "0";
                          _lowestController.clear();
                          _highestController.clear();
                          setState(() {});
                        }, 
                        child: const Text('Reset')
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
            } 
          ),
        ),
      ),
    );
  }
}