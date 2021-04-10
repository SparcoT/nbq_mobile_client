class VideoModel {
  String id, url, nameInEnglish, nameInSpanish;

  VideoModel({
    this.id,
    this.url,
    this.nameInEnglish,
    this.nameInSpanish,
  });

  VideoModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    nameInSpanish = json['spanish'];
    nameInEnglish = json['english'];
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'spanish': nameInSpanish,
      'english': nameInEnglish,
    };
  }
}
