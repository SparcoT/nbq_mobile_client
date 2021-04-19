
import 'package:nbq_mobile_client/src/base/services/_model.dart';

class ImageModel extends Model{
  String id,image,category;

  ImageModel({
    this.image,
    this.id,
    this.category,
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'image': image,
    };
  }
}
