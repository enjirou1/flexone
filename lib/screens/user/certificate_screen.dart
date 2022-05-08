import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/models/expert_result.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateScreen extends StatelessWidget {
  List<Certificate> certificates;

  CertificateScreen({Key? key, required this.certificates }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('certificates').tr(),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 15.0,
            runSpacing: 15.0,
            alignment: WrapAlignment.start,
            children: certificates.map<Widget>((certificate) {
              return GestureDetector(
                onTap: () => Get.to(PreviewImage(image: certificate.photo, detail: certificate.detail)),
                child: Image.network(certificate.photo, width: (MediaQuery.of(context).size.width - 50) / 3, height: (MediaQuery.of(context).size.width - 50) / 3, fit: BoxFit.cover)
              );
            }).toList()
          ),
        ),
      )
    );
  }
}