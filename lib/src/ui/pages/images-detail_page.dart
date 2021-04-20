import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/base/services/images_service.dart';
import 'package:nbq_mobile_client/src/firebase-videos/image_model.dart';
import 'package:nbq_mobile_client/src/ui/widgets/simple-stream-builder.dart';
import 'package:nbq_mobile_client/src/utils/constants.dart';

import 'package:nbq_mobile_client/src/ui/pages/image_page.dart'
    if (dart.library.io) 'package:nbq_mobile_client/src/ui/pages/image_page_io.dart'
    if (dart.library.html) 'package:nbq_mobile_client/src/ui/pages/image_page_web.dart';

class ImagesDetailPage extends StatefulWidget {
  final String title;

  ImagesDetailPage({this.title});

  @override
  _ImagesDetailPageState createState() => _ImagesDetailPageState();
}

class _ImagesDetailPageState extends State<ImagesDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SimpleStreamBuilder.simpler(
        stream: ImagesService().fetchByCategory(widget.title),
        builder:(List<ImageModel> images)=> kIsWeb ? Scrollbar(
          isAlwaysShown: true,
            thickness: 15,
            child: imgGrid(images)) : imgGrid(images),
      ),
    );
  }

  Widget imgGrid(List<ImageModel> images)=>GridView.builder(
    itemCount: images.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: kIsWeb ? 5 : 2,
      crossAxisSpacing: kIsWeb ? 12 : 4.0,
      mainAxisSpacing: kIsWeb ? 12.0 : 4.0,
    ),
    itemBuilder: (ctx, index) {
      final _image = images[index].image;
      final image = Image.network(
        _image,
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
      );

      return InkWell(
        onTap: () {
          return AppNavigation.navigateTo(
            context,
            createImagePage(image: _image, imageWidget: image),
          );
        },
        child: Hero(tag: _image, child: image),
      );
    },
  );
}
