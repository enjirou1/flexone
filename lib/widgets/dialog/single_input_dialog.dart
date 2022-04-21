import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flutter/material.dart';

class SingleInputDialog extends StatelessWidget {
  String title;
  String label;
  String buttonText;
  TextEditingController controller;
  InputValidation inputValidation;
  TextInputType inputType;
  bool obsecureText;
  Function() onPressed;

  SingleInputDialog(
      {Key? key,
      required this.title,
      required this.label,
      required this.buttonText,
      required this.controller,
      required this.inputValidation,
      required this.inputType,
      required this.obsecureText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      actionsPadding:
          const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 10),
      title: Text(title),
      actions: [
        TextField(
            controller: controller,
            keyboardType: inputType,
            obscureText: obsecureText,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                labelText: label,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: secondaryColor)),
                labelStyle: TextStyle(color: secondaryColor),
                errorText:
                    inputValidation.isValid ? null : inputValidation.message)),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText).tr()),
        )
      ],
    );
  }
}
