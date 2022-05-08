import 'package:easy_localization/easy_localization.dart';
import 'package:flexone/data/models/expert_result.dart';
import 'package:flexone/data/providers/certificates.dart';
import 'package:flexone/data/providers/user.dart';
import 'package:flexone/widgets/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _certificateProvider = Provider.of<CertificateProvider>(context, listen: true);
    final _provider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('certificates').tr(),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Get.toNamed('add_certificate');
              if (result) {
                Get.snackbar(
                  tr('success'), tr('success_detail.add_certificate'),
                  snackPosition: SnackPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  icon: const Icon(Icons.check, color: Colors.white),
                  duration: const Duration(seconds: 1)
                );
              }
            }, 
            icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 15.0,
            runSpacing: 15.0,
            alignment: WrapAlignment.start,
            children: _certificateProvider.certificates.map<Widget>((certificate) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(PreviewImage(image: certificate.photo, detail: certificate.detail)),
                    child: Image.network(certificate.photo, width: (MediaQuery.of(context).size.width - 50) / 3, height: (MediaQuery.of(context).size.width - 50) / 3, fit: BoxFit.cover)
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        await Expert.deleteCertificate(_provider.user!.expertId!, certificate.certificateId);
                        _certificateProvider.removeCertificate(certificate.certificateId);
                      } catch (e) {
                        Get.snackbar('Error', e.toString(),
                          snackPosition: SnackPosition.BOTTOM,
                          animationDuration: const Duration(milliseconds: 300),
                          duration: const Duration(seconds: 2)
                        );
                      }
                    },
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: Align(
                        alignment: Alignment.topRight, 
                        child: Icon(Icons.delete, color: Colors.red[800])
                      )
                    ),
                  )
                ]
              );
            }).toList()
          ),
        ),
      )
    );
  }
}