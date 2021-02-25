

import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/ui/pages/images-detail_page.dart';

import '../../app.dart';

class DesignImages extends StatefulWidget {
  @override
  _DesignImagesState createState() => _DesignImagesState();
}

class _DesignImagesState extends State<DesignImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
         _tile("Diseños"),
         _tile("Expositores"),
         _tile("Marketing"),
         _tile("Sprays"),
        ],
      ),
    );
  }

  Widget _tile(String title){
    return Padding(
      padding: const EdgeInsets.only(bottom:20.0),
      child: ListTile(
        leading: Image.asset("assets/icons/folder_pink.png"),
        title: Text(title,style: TextStyle(
            fontFamily: 'Futura',
            fontWeight: FontWeight.bold,fontSize: 20),),
        onTap: () =>
          AppNavigation.navigateTo(context, ImagesDetailPage(title: title)),
      ),
    );
  }
}
