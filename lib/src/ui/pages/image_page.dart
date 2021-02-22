import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  final String image;

  ImagePage({this.image});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: image,
      child: SafeArea(
        child: InteractiveViewer(
          panEnabled: true,
          child: Image.network(
            image,
            fit: BoxFit.fitWidth,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
