import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadService {
  static Future<String> uploadImage(XFile file, String folder, String id) async {
    String? filename = file.path;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(folder)
        .child('${DateTime.now().millisecondsSinceEpoch}-$id');
    UploadTask task = ref.putFile(File(filename));
    TaskSnapshot snapshot = await task;
    return await snapshot.ref.getDownloadURL();
  }

  static Future<String> uploadFile(File file, String folder, String id) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(folder)
        .child('${DateTime.now().millisecondsSinceEpoch}-$id');
    UploadTask task = ref.putFile(file);
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
