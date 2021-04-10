import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/data/video_model.dart';
import 'package:nbq_mobile_client/src/ui/pages/video_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class TestVideosPage extends StatefulWidget {
  @override
  _TestVideosPageState createState() => _TestVideosPageState();
}

class _TestVideosPageState extends State<TestVideosPage> {
  List<VideoModel> videosList;
  List<VideoModel> searchedList;

  Future<File> _convertVideoToThumbnail(String url) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64,
      quality: 80,
      video: url,
    );

    return File(fileName);
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('vidoe')
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
    return Scaffold(
      appBar: AppBar(title: Text("Test")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Text(
                  'Test'.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                SizedBox(width: 15),
                // Expanded(
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(vertical: 15),
                //       child: Center(
                //         child: Text(
                //           'Buscar'.toUpperCase(),
                //           style: TextStyle(
                //             color: Colors.grey,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ),
                //     decoration: BoxDecoration(
                //         color: Colors.white54,
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.grey.withOpacity(0.5),
                //             spreadRadius: 1,
                //             blurRadius: 10,
                //             offset: Offset(0, 3), // changes position of shadow
                //           ),
                //         ],
                //         borderRadius: BorderRadius.circular(8)),
                //   ),
                // ),
              ],
            ),
          ),
          TextFormField(
            onChanged: (e) {
              print(e);
              searchedList = videosList
                  .where((element) => (element.nameInEnglish
                          .toLowerCase()
                          .contains(e.toLowerCase()) ||
                      element.nameInSpanish
                          .toLowerCase()
                          .contains(e.toLowerCase())))
                  .toList();

              setState(() {});
            },
          ),
          if (videosList == null)
            CircularProgressIndicator()
          else
            Expanded(
              child: GridView.builder(
                itemCount: searchedList.length,
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (ctx, i) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: _convertVideoToThumbnail(searchedList[i].url),
                          builder: (ctx, AsyncSnapshot<File> file) {
                            if (file.hasData) {
                              return GestureDetector(
                                onTap: () => AppNavigation.navigateTo(
                                  context,
                                  VideoPage(
                                    url: searchedList[i].url,
                                  ),
                                ),
                                child: Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue,
                                    image: DecorationImage(
                                      image: FileImage(file.data),
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
                              );
                            } else {
                              return Container(
                                height: 140,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              searchedList[i].nameInEnglish,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
    );
  }
}