import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';
import 'package:nbq_mobile_client/src/ui/pages/home_page.dart';
import 'package:nbq_mobile_client/src/ui/pages/nbq-map.dart';
import 'package:nbq_mobile_client/src/ui/pages/signin.dart';
import 'package:nbq_mobile_client/src/ui/pages/test-videos_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
 var crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 40,
        crossAxisSpacing: 40,
        childAspectRatio: 2/0.7),
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
            HomePageState.tabController.animateTo(1);
          }),
      imageCon(
          url: Assets.multiMedia,
          function: () {
            HomePageState.tabController.animateTo(2);
          }),

    ],)
        : ListView(
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
                    HomePageState.tabController.animateTo(1);
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
      padding: kIsWeb
        ?EdgeInsets.all( 15):
      EdgeInsets.only( bottom: 15),
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
//              image: DecorationImage(
//                image: AssetImage(url),
//                fit: BoxFit.fill,
//              ),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(url, fit: BoxFit.fill,
                  cacheWidth: MediaQuery.of(context).size.width.toInt(),
                )),
          ),
        ),
      ),
    );
  }
}
