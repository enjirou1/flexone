import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/providers/module.dart';
import 'package:flexone/data/providers/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:provider/provider.dart';

class ModuleScreen extends StatelessWidget {
  QuillController? _controller;
  final ScrollController _scrollController = ScrollController();

  ModuleScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _preferenceProvider = Provider.of<PreferencesProvider>(context, listen: false);
    final _provider = Provider.of<ModuleProvider>(context, listen: true);
    Module module = _provider.modules[_provider.currentIndex];
    final content = jsonDecode(module.content);

    if (content != "") {
      _controller = QuillController(
        document: Document.fromJson(jsonDecode(content)), 
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _controller = QuillController.basic();
    }

    return Theme(
      data: _preferenceProvider.isDarkTheme ? 
        darkTheme.copyWith(
          dialogTheme: DialogTheme(
            backgroundColor: Colors.indigo[200]
          ),
        ) : lightTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(module.name, style: notoSansDisplayTheme.bodyText1),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              QuillEditor(
                showCursor: false, 
                controller: _controller!, 
                focusNode: FocusNode(), 
                scrollController: _scrollController, 
                scrollable: true, 
                padding: const EdgeInsets.only(top: 10, right: 10, bottom: 75, left: 10), 
                autoFocus: true, 
                readOnly: true, 
                expands: false,
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: ElevatedButton(
                          onPressed: (_provider.currentIndex - 1 >= 0) ? () {
                            _provider.previous();
                            _scrollController.jumpTo(0);
                          } : null, 
                          child: const Text('previous').tr(),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: ElevatedButton(
                          onPressed: (_provider.currentIndex + 1 < _provider.modules.length) ? () {
                            _provider.next();
                            _scrollController.jumpTo(0);
                          } : null, 
                          child: const Text('next').tr()
                        ),
                      )
                    ],
                  ),
                )
              )
            ],
          ),
        )
      ),
    );
  }
}