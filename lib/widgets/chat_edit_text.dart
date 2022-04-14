import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatEditText extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  Function() onSubmit;
  bool followed;

  ChatEditText({ Key? key, required this.controller, required this.onSubmit, required this.followed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _fontColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;
    final Color? _containerColor = _preferencesProvider.isDarkTheme ? Colors.black38 : secondaryColor;
    final Color? _editTextColor = _preferencesProvider.isDarkTheme ? Colors.grey[800] : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: _containerColor,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: _fontColor),
              cursorColor: Colors.indigo,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                enabled: followed,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                isDense: true,
                fillColor: _editTextColor,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                hintText: "type_something".tr(),
              ),
            ),
          ),
          IconButton(
            onPressed: onSubmit, 
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            )
          )
        ],
      ),
    );
  }
}