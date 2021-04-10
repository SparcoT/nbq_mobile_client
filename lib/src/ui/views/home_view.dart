import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';
import 'package:nbq_mobile_client/src/ui/pages/home_page.dart';
import 'package:nbq_mobile_client/src/ui/pages/nbq-map.dart';
import 'package:nbq_mobile_client/src/ui/pages/test-videos_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(20),
      children: [
        imageCon(
            url: Assets.test,
            function: () {
              AppNavigation.navigateTo(context, TestVideosPage());
            }
            // widget: TestVideosPage(),
            ),
        imageCon(
            url: Assets.world,
            function: () {
              AppNavigation.navigateTo(context, NBQMap());
            }),
        imageCon(
            url: Assets.pedidos,
            function: () {
              HomePageState.tabController.animateTo(3);
            }),
        imageCon(
          url: Assets.multiMedia,
            function: () {
              HomePageState.tabController.animateTo(2);
            }),
      ],
    );
  }

  Widget imageCon({String url, Function function}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(22),
        child: GestureDetector(
          onTap: function,
          child: Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              image: DecorationImage(
                image: AssetImage(url),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
