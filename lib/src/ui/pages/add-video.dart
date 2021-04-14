import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nbq_mobile_client/src/utils/lazy_task.dart';
import 'package:nbq_mobile_client/src/firebase-videos/video_model.dart';
import 'package:nbq_mobile_client/src/firebase-videos/firebase-storage-service.dart';

import 'package:nbq_mobile_client/src/utils/thumbnail/thumbnail.dart'
    if (dart.library.html) 'package:nbq_mobile_client/src/utils/thumbnail/thumbnail_html.dart';

class AddVideos extends StatefulWidget {
  @override
  _AddVideosState createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {
  File video;
  Uint8List videoBytes;
  Uint8List videoThumbnail;

  @override
  void initState() {
    super.initState();
    nameInEnglish = TextEditingController();
    nameInSpanish = TextEditingController();
  }

  openGallery(BuildContext context) async {
    var picture = await ImagePicker().getVideo(source: ImageSource.gallery);

    if (picture != null) {
      videoBytes = await picture.readAsBytes();
      videoThumbnail = await getVideoThumbnail(picture.path);
      this.setState(() {
        video = File(picture.path);
      });
    }
  }

  onImageDeleted() {
    setState(() {
      videoThumbnail = null;
      video = null;
      videoBytes = null;
    });
  }

  var key = GlobalKey<FormState>();
  TextEditingController nameInEnglish;

  TextEditingController nameInSpanish;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Video"),
      ),
      body: Form(
        key: key,
        child: SingleChildScrollView(
          padding: kIsWeb
              ? EdgeInsets.symmetric(
                  vertical: 100,
                  horizontal: MediaQuery.of(context).size.width / 3)
              : EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: nameInEnglish,
                      validator: (nameEng) {
                        return nameEng.isEmpty ? "Name Required" : null;
                      },
                      decoration: InputDecoration(
                        hintText: "Name in English",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      validator: (nameSpan) {
                        return nameSpan.isEmpty ? "Name Required" : null;
                      },
                      controller: nameInSpanish,
                      decoration: InputDecoration(
                        hintText: "Name in Spanish",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  if (video == null)
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1, color: Colors.grey)),
                          height: 200,
                          width: 300,
                          child: Center(
                            child: Text("No Video"),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                          onPressed: () => openGallery(context),
                          child: Text('Choose Video'),
                        ),
                      ],
                    ),
                  if (video != null)
                    Container(
                      height: 200,
                      width: 300,
                      child: IconButton(
                        alignment: Alignment.topRight,
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.pink,
                        ),
                        onPressed: onImageDeleted,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(
                            videoThumbnail,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (video != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            if (key.currentState.validate()) {
                              await performLazyTask(context, () async {
                                var vidUrl =
                                    await FirebaseStorageService.uploadVideo(
                                        videoBytes, video.path);
                                var imgUrl =
                                    await FirebaseStorageService.uploadImage(
                                        videoThumbnail, video.path);
                                await FirebaseFirestore.instance
                                    .collection('videos')
                                    .add(VideoModel(
                                      nameInEnglish: nameInEnglish.text,
                                      nameInSpanish: nameInSpanish.text,
                                      video: vidUrl,
                                      image: imgUrl,
                                    ).toJson());
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Video Uploaded Successfully'),
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text("Submit"),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
