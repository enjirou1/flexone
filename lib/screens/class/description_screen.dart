import 'dart:convert';
import 'dart:io';
import 'package:flexone/common/style.dart';
import 'package:flexone/data/services/upload_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DescriptionScreen extends StatefulWidget {
  String description;
  String expertId;

  DescriptionScreen({ Key? key, required this.description, required this.expertId }) : super(key: key);

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  QuillController? _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.description != "") {
      final doc = Document.fromJson(jsonDecode(widget.description));
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
          title: const Text("description").tr(),
          actions: [
            IconButton(
              onPressed: () async {
                var json = jsonEncode(_controller!.document.toDelta().toJson());
                Get.back(result: json);
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
    final String image = await UploadService.uploadFile(file, "class", widget.expertId);
    return image;
  }

  Future<String> _onVideoPickCallback(File file) async {
    final String video = await UploadService.uploadFile(file, "class", widget.expertId);
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