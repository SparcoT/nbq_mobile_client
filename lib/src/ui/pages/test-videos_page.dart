import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/firebase-videos/video_model.dart';
import 'package:nbq_mobile_client/src/ui/pages/video_page.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/localization_selector.dart';

class UserVideosPage extends StatefulWidget {
  @override
  _UserVideosPageState createState() => _UserVideosPageState();
}

class _UserVideosPageState extends State<UserVideosPage> {
  List<VideoModel> videosList;
  List<_IndexTuple> searchList;
  List<_IndexTuple> indexesList;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('videos')
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => VideoModel.fromJson(e.data())..id = e.id)
              .toList(),
        )
        .listen((event) {
      if (event != null) {
        videosList = event;
        indexesList =
            List.generate(videosList.length, (index) => _IndexTuple(index, 0));
        searchList = indexesList;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (ctx, lang) => Scaffold(
        appBar: AppBar(title: Text(lang.test)),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CupertinoTextField(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                placeholderStyle: TextStyle(fontSize: 14),
                placeholder: lang.searchVideo,
                onChanged: (e) {
                  if (e.isEmpty) {
                    searchList = indexesList;
                    setState(() {});

                    return;
                  }

                  searchList = [];
                  for (var i = 0; i < videosList.length; ++i) {
                    String text;
                    if (LocalizationSelector.locale.value.languageCode ==
                        'en') {
                      text = videosList[i].nameInEnglish;
                    } else {
                      text = videosList[i].nameInSpanish;
                    }

                    final matchResult = matchingDegree(text, e);
                    if (matchResult >= 0) {
                      searchList.add(_IndexTuple(i, matchResult));
                    }
                  }

                  searchList.sort((a, b) => b.score.compareTo(a.score));
                  setState(() {});
                },
              ),
            ),
            if (videosList == null)
              CircularProgressIndicator()
            else
              Expanded(
                child: kIsWeb
                    ? Scrollbar(
                        isAlwaysShown: true,
                        thickness: 15,
                        child: videosBuilder())
                    : videosBuilder(),
              ),
          ],
        ),
      ),
    );
  }

  Widget videosBuilder() => GridView.builder(
        itemCount: searchList.length,
        padding: EdgeInsets.symmetric(horizontal: 8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? 5 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          // childAspectRatio: MediaQuery.of(context).size.width / 5
        ),
        itemBuilder: (ctx, i) {
          final video = videosList[searchList[i].index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => AppNavigation.navigateTo(
                      context,
                      VideoPage(
                        url: video.video,
                        videoName:
                            LocalizationSelector.locale.value.languageCode ==
                                    'en'
                                ? video.nameInEnglish
                                : video.nameInSpanish,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(55),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                        image: DecorationImage(
                          image: NetworkImage(video.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.pink,
                          child: Icon(CupertinoIcons.play),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Text(
                      LocalizationSelector.locale.value.languageCode == 'en'
                          ? video.nameInEnglish
                          : video.nameInSpanish,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}

int matchingDegree(String source, String query) {
  source = source.toLowerCase();
  final keywords =
      query.toLowerCase().split(' ').where((_) => _.isNotEmpty).toList();

  if (keywords.isEmpty) return 0;

  var degree = 0;
  var lastMatch = 0;
  for (var i = 0; i < keywords.length; ++i) {
    final keyword = keywords[i];

    for (var j = lastMatch; j < source.length;) {
      var hasMatch = true;

      var k = 0;
      for (; k < keyword.length; ++k) {
        if (keyword[k] != source[j + k]) {
          ++k;
          hasMatch = false;
          break;
        }
      }

      if (hasMatch) {
        degree += keywords.length - i;
        lastMatch = j + k;
      } else if (j + k < source.length) {
        j += k;
        continue;
      }

      break;
    }
  }

  return degree;
}

class _IndexTuple {
  final int index;
  final int score;

  const _IndexTuple(this.index, this.score);
}
