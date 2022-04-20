import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SearchEditText extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  Function(String value) onSubmitted;
  Function() onClear;
  Function(String value) onChanged;
  Function()? onPressed;

  SearchEditText({ Key? key, required this.controller, required this.onSubmitted, required this.onClear, required this.onChanged, this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _preferencesProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final Color _textColor = _preferencesProvider.isDarkTheme ? Colors.white : Colors.black;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onSubmitted: onSubmitted,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: _textColor)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: _textColor)
              ),
              hintText: "search".tr(),
              hintStyle: TextStyle(
                color: _textColor
              ),
              suffixIcon: IconButton(
                icon: const FaIcon(FontAwesomeIcons.xmark), 
                onPressed: onClear,
              )
            ),
            style: TextStyle(color: _textColor),
          ),
        ),
        if (onPressed != null) ...[
          IconButton(
            onPressed: onPressed, 
            icon: const FaIcon(FontAwesomeIcons.filter)
          )
        ]
      ],
    );
  }
}