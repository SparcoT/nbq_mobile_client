import 'package:flutter/foundation.dart';
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
  static const _sidePad = 20;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 700 ? 1 : 2;
        final itemWidth =
            (constraints.maxWidth - (_sidePad * crossAxisCount) - _sidePad) ~/
                crossAxisCount;
        final itemHeight = (itemWidth * .3).toInt();

        return GridView.count(
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 3.2,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          crossAxisCount: crossAxisCount,
          children: <Widget>[
            _HomeViewItem(
              width: itemWidth,
              image: Assets.test,
              height: itemHeight,
              onTap: () {
                AppNavigation.navigateTo(context, UserVideosPage());
              },
            ),
            _HomeViewItem(
              width: itemWidth,
              height: itemHeight,
              image: Assets.world,
              onTap: () {
                AppNavigation.navigateTo(context, NBQMap());
              },
            ),
            _HomeViewItem(
              width: itemWidth,
              height: itemHeight,
              image: Assets.pedidos,
              onTap: () {
                HomePageState.tabController.animateTo(1);
              },
            ),
            _HomeViewItem(
              width: itemWidth,
              height: itemHeight,
              image: Assets.multimedia,
              onTap: () {
                HomePageState.tabController.animateTo(2);
              },
            ),
          ],
        );
      },
    );
  }
}

class _HomeViewItem extends Container {
  _HomeViewItem({String image, int width, int height, VoidCallback onTap})
      : super(
          clipBehavior: Clip.antiAlias,
          constraints: BoxConstraints(
            maxWidth: width.toDouble(),
            maxHeight: height.toDouble(),
          ),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: ResizeImage(
                AssetImage(image),
                width: width,
                height: height,
              ),
            ),
          ),
          child: GestureDetector(onTap: onTap),
        );
}
