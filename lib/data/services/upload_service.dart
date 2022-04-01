import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadService {
  static Future<String> uploadImage(XFile file, String uid) async {
    String? filename = file.path;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('user')
        .child('${DateTime.now().millisecondsSinceEpoch}-$uid');
    UploadTask task = ref.putFile(File(filename));
    TaskSnapshot snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  static Future<XFile?> getImage(int type) async {
    if (type == 0) {
      return await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      return await ImagePicker().pickImage(source: ImageSource.gallery);
    }
  }
}
