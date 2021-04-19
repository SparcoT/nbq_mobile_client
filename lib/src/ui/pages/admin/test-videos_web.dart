// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/firebase-videos/video_model.dart';
import 'package:nbq_mobile_client/src/ui/pages/admin/add-video.dart';
import 'package:nbq_mobile_client/src/ui/pages/video_page.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/localization_selector.dart';
import 'package:nbq_mobile_client/src/utils/lazy_task.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

class TestVideosPageWeb extends StatefulWidget {
  @override
  _TestVideosPageWebState createState() => _TestVideosPageWebState();
}

class _TestVideosPageWebState extends State<TestVideosPageWeb> {
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
  //   print('thumb file name');
  //   print(fileName);
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
        print('data');
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            AppNavigation.navigateTo(context, AddVideos());
          },
        ),
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
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (ctx, i) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
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
                                  height: 220,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    // color: Colors.blue,
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(searchedList[i].image),
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
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
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
                        ),
                        IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () async {
                            try {
                              openLoadingDialog(context, 'Deleting');
                              await FirebaseStorage.instance
                                  .refFromURL(searchedList[i].video)
                                  .delete();
                              await FirebaseStorage.instance
                                  .refFromURL(searchedList[i].image)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection('videos')
                                  .doc(searchedList[i].id)
                                  .delete();
                              Navigator.of(context).pop();
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ],
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
