
class VideoModel{
String id,video,image, nameInEnglish, nameInSpanish;

  VideoModel({
    this.video,
    this.image,
    this.nameInEnglish,
    this.nameInSpanish,
  });

  VideoModel.fromJson(Map<String, dynamic> json) {
    video = json['video'];
    image = json['image'];
    nameInSpanish = json['spanish'];
    nameInEnglish = json['english'];
  }

  Map<String, dynamic> toJson() {
    return {
      'video': video,
      'image': image,
      'spanish': nameInSpanish,
      'english': nameInEnglish,
    };
  }
}


