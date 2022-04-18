import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  String title;
  String? content;
  String buttonText;
  Function() onCancel;
  Function() onPressed;

  ConfirmationDialog({ Key? key, required this.title, this.content, required this.buttonText, required this.onCancel, required this.onPressed }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title.tr()),
      content: (content != null) ? Text(content!.tr()) : null,
      actions: [
        TextButton(onPressed: onCancel, child: const Text('cancel').tr()),
        TextButton(onPressed: onPressed, child: Text(buttonText).tr())
      ],
    );
  }
}