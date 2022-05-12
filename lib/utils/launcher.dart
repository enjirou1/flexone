import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class Launcher {
  static Future launchInWebView(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'},
        ),
      );
    }
  }

  static Future launchExternalApplication(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // static Future launchWhatsapp() async{
  //   const String phone = "6282233033995";
  //   const String whatsappURlAndroid = "https://api.whatsapp.com/send?phone=$phone";
  //   final String whatappURLIOS = "https://wa.me/$phone/?text=${Uri.parse("")}";

  //   if(Platform.isIOS){
  //     if(await launchUrl(Uri.parse(whatappURLIOS))){
  //       await launchUrl(
  //         Uri.parse(whatappURLIOS),
  //         mode: LaunchMode.externalApplication,
  //       );
  //     }
  //   }else{
  //     if(await canLaunchUrl(Uri.parse(whatsappURlAndroid))){
  //       await launchUrl(
  //         Uri.parse(whatsappURlAndroid),
  //         mode: LaunchMode.externalApplication,
  //       );
  //     }
  //   }
  // }
}