import 'dart:convert';
import 'dart:io';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/models/class_result.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class EditorScreen extends StatefulWidget {
  String? classId;
  int? sectionId;
  int? moduleId;
  String name;
  String content;

  EditorScreen({ Key? key, this.classId, required this.name, this.sectionId, this.moduleId, required this.content }) : super(key: key);

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final TextEditingController _textController = TextEditingController();
  QuillController? _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  InputValidation _validation = InputValidation(isValid: true, message: '');

  @override
  void initState() {
    super.initState();
    _textController.text = widget.name;

    if (widget.content != "") {
      final doc = Document.fromJson(jsonDecode(widget.content));
      setState(() {
        _controller = QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightTheme,
      child: Scaffold(
        appBar: AppBar(
          leading: Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () => Get.back(result: null),
              icon: const FaIcon(FontAwesomeIcons.xmark)
            )
          ),
          title: (widget.classId == null) ? const Text("edit_module").tr() : const Text("new_module").tr(),
          actions: [
            IconButton(
              onPressed: () async {
                bool isValid = true;

                if (_textController.text.isEmpty) {
                  isValid = false;
                  _validation = InputValidation(isValid: false, message: tr('error.name.empty'));
                } else {
                  _validation = InputValidation(isValid: true, message: '');
                }

                if (isValid) {
                  var json = jsonEncode(_controller!.document.toDelta().toJson());
                  
                  if (widget.classId == null) {
                    await Class.updateModule(widget.moduleId!, _textController.text, json);
                  } else {
                    await Class.addModule(widget.classId!, widget.sectionId!, _textController.text, json);
                  }
                  
                  Get.back(result: true);
                }

                setState(() {});
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              )
            )
          ]
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: tr("name"),
                  errorText: _validation.isValid ? null : _validation.message,
                  isDense: true
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: QuillEditor(
                controller: _controller!, 
                focusNode: _focusNode, 
                scrollController: ScrollController(), 
                scrollable: true, 
                padding: const EdgeInsets.all(10), 
                autoFocus: false, 
                readOnly: false, 
                expands: false,
              )
            ),
            QuillToolbar.basic(
              controller: _controller!,
              onImagePickCallback: _onImagePickCallback,
              onVideoPickCallback: _onVideoPickCallback,
              mediaPickSettingSelector: _selectMediaPickSetting,
              showAlignmentButtons: true,
            )
          ],
        ),
      ),
    );
  }

  Future<String> _onImagePickCallback(File file) async {
    final String image = await UploadService.uploadFile(file, "class", 'S${widget.sectionId}');
    return image;
  }

  Future<String> _onVideoPickCallback(File file) async {
    final String video = await UploadService.uploadFile(file, "class", 'S${widget.sectionId}');
    return video;
  }

  Future<MediaPickSetting?> _selectMediaPickSetting(BuildContext context) {
    return showDialog<MediaPickSetting>(
      context: context,
      builder: (ctx) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.collections),
              label: const Text('Gallery'),
              onPressed: () {
                Navigator.pop(ctx, MediaPickSetting.Gallery);
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.link),
              label: const Text('Link'),
              onPressed: () {
                Navigator.pop(ctx, MediaPickSetting.Link);
              },
            )
          ],
        ),
      ),
    );
  }
}