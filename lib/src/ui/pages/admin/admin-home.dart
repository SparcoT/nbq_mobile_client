import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'manage-images.dart';
import 'test-videos_web.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: ElevatedButton(
                  onPressed: (){
                    AppNavigation.navigateTo(context, ManageImages());
                  },
                  child: Text("Images")),
            ),
            SizedBox(width: 100,),
            SizedBox(
              height: 200,
              width: 200,
              child: ElevatedButton(onPressed: (){
                AppNavigation.navigateTo(context, TestVideosPageWeb());
              },
                  child: Text("Videos")),
            ),
          ],
        ),
      ),
    );
  }
}
