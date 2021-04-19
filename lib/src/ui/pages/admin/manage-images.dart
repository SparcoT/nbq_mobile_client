import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/base/services/firebasefirestore-service.dart';
import 'package:nbq_mobile_client/src/base/services/images_service.dart';
import 'package:nbq_mobile_client/src/firebase-videos/image_model.dart';
import 'package:nbq_mobile_client/src/ui/widgets/simple-stream-builder.dart';
import 'package:nbq_mobile_client/src/utils/lazy_task.dart';
import '../../../app.dart';
import 'add-images.dart';

class ManageImages extends StatefulWidget {
  @override
  _ManageImagesState createState() => _ManageImagesState();
}

class _ManageImagesState extends State<ManageImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images'),
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          AppNavigation.navigateTo(context, AddImages());
        },
      ),
      body: SimpleStreamBuilder.simpler(
        stream: ImagesService().fetchAllFirestore(),
        builder: (List<ImageModel> images){
          return GridView.builder(
          itemCount: images.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:  5 ,
            crossAxisSpacing:  12,
            mainAxisSpacing:  12.0 ,
          ),
          itemBuilder: (ctx, index) {
            return Stack(
              children: [
                Image.network(
                  images[index].image,
                  fit: BoxFit.fill,
                  // height: 300,
                  cacheHeight: 200,
                  cacheWidth: 200,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                Container(
                  color: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.cancel,color: Colors.red,),
                    onPressed: () async {
                      try {
                        await performLazyTask(context, () async {
                          await FirebaseStorage.instance
                              .refFromURL(images[index].image)
                              .delete();
                          await ImagesService().deleteFirestore(images[index].id);
                        },message: 'Deleting');
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        );},
      ),
    );
  }
}
