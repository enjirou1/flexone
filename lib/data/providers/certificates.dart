import 'package:flexone/data/models/expert_result.dart';
import 'package:flutter/material.dart';

class CertificateProvider extends ChangeNotifier {
  List<Certificate> _certificates = [];

  List<Certificate> get certificates => _certificates;

  void setCertificates(List<Certificate> data) {
    _certificates.clear();
    _certificates = data;
    notifyListeners();
  }

  Future addCertificate(Certificate certificate) async {
    _certificates.add(certificate);
    notifyListeners();
  }

  Future removeCertificate(String id) async {
    _certificates.removeWhere((certificate) => certificate.certificateId == id);
    notifyListeners();
  }
}