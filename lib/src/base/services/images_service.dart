import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nbq_mobile_client/src/base/services/firebasefirestore-service.dart';
import 'package:nbq_mobile_client/src/firebase-videos/image_model.dart';

class ImagesService extends NBQService<ImageModel> {
  @override
  String get collectionName => 'images';

  @override
  ImageModel parseModel(DocumentSnapshot document) {
    return ImageModel.fromJson(document.data())..id = document.id;
  }

  Stream<List<ImageModel>> fetchByCategory(String category) => FirebaseFirestore.instance
      .collection(collectionName).where('category',isEqualTo: category)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((document) => parseModel(document)).toList());

}
