import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
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
                "rating": rating == "0" ? null : rating
              });
            },
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            )
          )
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('price', style: poppinsTheme.headline5).tr(),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lowestController,
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
                    decoration: InputDecoration(
                      labelText: tr("highest_price"),
                      labelStyle: TextStyle(color: _borderColor),
                      isDense: true
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text('Rating', style: poppinsTheme.headline5).tr(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
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
                    title: item == "0" ? const Text('all').tr() : item == "5" ? const Text('5') : const Text('rating_rb').tr(args: [item.toString()]),
                    dense: true,
                  );
                }).toList()
              ),
            )
          ],
        ),
      ),
    );
  }
}