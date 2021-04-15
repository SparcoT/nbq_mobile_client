
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/firebase-videos/video_model.dart';
import 'package:nbq_mobile_client/src/ui/pages/video_page.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/localization_selector.dart';

class TestVideosPage extends StatefulWidget {
  @override
  _TestVideosPageState createState() => _TestVideosPageState();
}

class _TestVideosPageState extends State<TestVideosPage> {
  List<VideoModel> videosList;
  List<VideoModel> searchedList;

  // Future<File> _convertVideoToThumbnail(String url) async {
  //   final fileName = await VideoThumbnail.thumbnailFile(
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.WEBP,
  //     maxHeight: 64,
  //     quality: 80,
  //     video: url,
  //   );
  //
  //   return File(fileName);
  // }

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
        searchedList = event;

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
                  if (LocalizationSelector.locale.value.languageCode == 'en') {
                    searchedList = videosList
                        .where((element) => element.nameInEnglish
                            .toLowerCase()
                            .contains(e.toLowerCase()))
                        .toList();
                  } else {
                    searchedList = videosList
                        .where((element) => element.nameInSpanish
                            .toLowerCase()
                            .contains(e.toLowerCase()))
                        .toList();
                  }
                  setState(() {});
                },
              ),
            ),
            if (videosList == null)
              CircularProgressIndicator()
            else
              Expanded(
                child: GridView.builder(
                  itemCount: searchedList.length,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kIsWeb ? 5 : 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    // childAspectRatio: MediaQuery.of(context).size.width / 5
                  ),
                  itemBuilder: (ctx, i) {
                    print(searchedList[i].image);
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
                                  url: searchedList[i].video,
                                  videoName: LocalizationSelector
                                              .locale.value.languageCode ==
                                          'en'
                                      ? searchedList[i].nameInEnglish
                                      : searchedList[i].nameInSpanish,
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(55),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue,
                                  image: DecorationImage(
                                    image: NetworkImage(searchedList[i].image),
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 4),
                              child: Text(
                                LocalizationSelector
                                            .locale.value.languageCode ==
                                        'en'
                                    ? searchedList[i].nameInEnglish
                                    : searchedList[i].nameInSpanish,
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}
