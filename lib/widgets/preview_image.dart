import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/common/style.dart';
import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  String image;
  String? detail;

  PreviewImage({ Key? key, required this.image, this.detail }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("preview").tr(),
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              clipBehavior: Clip.none,
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(image)
            ),
          ),
          if (detail != null && detail != "")
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.5)
              ),
              child: Text(detail!, style: poppinsTheme.bodyText2)
            ),
          ),
        ],
      ),
    );
  }
}