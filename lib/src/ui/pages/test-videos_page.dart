import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
              .where((element) => element.video != null)
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
    return LayoutBuilder(builder: (context, constraints) {
      final parts = constraints.maxWidth ~/ 150;

      return LocalizedView(builder: (context, lang) {
        Widget child;
        if (videosList == null) {
          child = Center(child: CupertinoActivityIndicator());
        } else {
          child = GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              crossAxisCount: parts,
              childAspectRatio: 300 / 321.5,
            ),
            itemCount: searchList.length,
            itemBuilder: (context, i) {
              print(i);
              final video = videosList[searchList[i].index];
              final videoName = lang.localeName == 'en'
                  ? video.nameInEnglish
                  : video.nameInSpanish;

              return GestureDetector(
                onTap: () {
                  AppNavigation.navigateTo(
                    context,
                    VideoPage(url: video.video, videoName: videoName),
                  );
                },
                child: Column(children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            blurRadius: 10,
                          )
                        ],
                        image: DecorationImage(
                          image: NetworkImage(video.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white54,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.play_arrow_rounded),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 7.5),
                  Text(
                    videoName,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ]),
              );
            },
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(lang.test)),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: CupertinoSearchTextField(
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
            Expanded(child: child)
          ]),
        );
      });
    });
  }
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
        if (j + k < source.length && keyword[k] != source[j + k]) {
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
