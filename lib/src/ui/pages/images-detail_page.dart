import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/ui/pages/image_page.dart';
import 'package:nbq_mobile_client/src/utils/constants.dart';

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
      body: GridView.builder(
        itemCount: kImages[widget.title].length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemBuilder: (ctx, index) {
          final _image = kImages[widget.title][index];
          final image = Image.network(
            _image,
            fit: BoxFit.fill,
            // height: 300,
            // cacheHeight: 200,
            // cacheWidth: 200,
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
            onTap: () => AppNavigation.navigateTo(
              context,
              ImagePage(
                image: _image,
                imageWidget: image,
              ),
            ),
            child: Hero(tag: _image, child: image),
          );
        },
      ),
    );
  }
}
