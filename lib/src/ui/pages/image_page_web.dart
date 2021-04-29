import 'dart:html';

import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';

Widget createImagePage({String image, Widget imageWidget}) => WebImagePage(
  image: image,
  imageWidget: imageWidget,
);

class WebImagePage extends StatefulWidget {
  final String image;
  final Widget imageWidget;

  WebImagePage({this.image, this.imageWidget});

  @override
  _ImagePageWebState createState() => _ImagePageWebState();
}

class _ImagePageWebState extends State<WebImagePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (ctx, lang) => Scaffold(
        appBar: AppBar(),
        key: _scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Image.network(widget.image, fit: BoxFit.fill),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    final png = "image.jpeg";
                    AnchorElement()
                      ..download = png
                      ..href = widget.image
                      ..click();
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text('Image will be saved')));
                  },
                  icon: Icon(Icons.download_sharp),
                  label: Text(lang.download),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
