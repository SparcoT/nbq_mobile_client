import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:nbq_mobile_client/src/firebase-videos/service.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

abstract class FirebaseStorageService {

  static Future<String> uploadVideo(Uint8List path,String filePath) async {
    var fs = firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference firebaseStorageRef = fs.ref().child(DateTime.now().millisecondsSinceEpoch.toString());

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'video/mp4',
        customMetadata: {'picked-file-path': filePath});

    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putData(path,metadata);
    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  static Future<String> uploadImage(Uint8List path,String filePath) async {
    var fs = firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference firebaseStorageRef = fs.ref().child(DateTime.now().millisecondsSinceEpoch.toString());

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'application/image',
    );

    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putData(path,metadata);
    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }
}
