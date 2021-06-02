import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/data/db.g.g.dart';
import 'package:nbq_mobile_client/src/ui/views/cart_view.dart';
import 'package:nbq_mobile_client/src/ui/views/home_view.dart';
import 'package:nbq_mobile_client/src/ui/views/products_view.dart';
import 'package:nbq_mobile_client/src/ui/views/contact_us_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/localization_selector.dart';
import 'package:url_launcher/url_launcher.dart';
import 'design-images_page.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  HomePage({this.initialIndex = 0});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static TabController tabController;

  LazyBox<Product> box;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    box = Hive.lazyBox<Product>('products');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (box.isEmpty) {
        createDatabase();
      }
    });
  }

  createDatabase() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Text('Database is empty'),
        );
      },
    );

    for (var i = 0; i < products.length; ++i) {
      box.put('${products[i].category.index}$i', products[i]);
    }

    Navigator.of(context).pop();
  }

  List<Widget> barRow() {
    return kIsWeb
        ? [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: LocalizationSelector(),
            ),
            SizedBox(
              width: 100,
            ),
            Image.asset(Assets.logo, height: 45),
            SizedBox(
              width: 100,
            ),
            Expanded(
              child: TabBar(
                controller: tabController,
                indicatorWeight: 2,
                indicatorColor: AppTheme.primaryColor,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 17),
                tabs: [
                  _NavBarTab(Assets.homeIcon, context),
                  _NavBarTab(Assets.dropIcon, context),
                  _NavBarTab(Assets.folderIcon, context),
                  _NavBarTab(Assets.cartIcon, context),
                  _NavBarTab(Assets.contactIcon, context),
                ],
              ),
            )
          ]
        : [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: LocalizationSelector(),
            ),
            Image.asset(Assets.logo, height: 45, color: Colors.white),
            SizedBox(
              width: 60,
              child: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  launch(Platform.isAndroid
                      ? 'https://play.google.com/store/apps/details?id=com.sparkosol.nbq'
                      : 'https://apps.apple.com/us/app/nbq/id1555068851');
                },
              ),
            )
          ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TabBarView(
        controller: tabController,
        // physics: NeverScrollableScrollPhysics(),
        children: [
          CartView(),
          HomeView(),
          ProductsView(),
          DesignImages(),
          ContactUsView(),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15),
          child: Row(
            children: barRow(),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 35),
        child: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeView(),
            ProductsView(),
            DesignImages(),
            CartView(),
            ContactUsView()
          ],
        ),
      ),
      bottomNavigationBar: kIsWeb
          ? SizedBox()
          : BottomAppBar(
              elevation: 10,
              child: TabBar(
                controller: tabController,
                indicatorWeight: 2,
                indicatorColor: AppTheme.primaryColor,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 17),
                tabs: [
                  _NavBarTab(Assets.homeIcon, context, 32, 32),
                  _NavBarTab(Assets.dropIcon, context),
                  _NavBarTab(Assets.folderIcon, context, 26, 26),
                  _NavBarTab(Assets.cartIcon, context),
                  _NavBarTab(Assets.contactIcon, context, 28, 28),
                ],
              ),
            ),
    );
  }
}

class _NavBarTab extends Tab {
  _NavBarTab(String asset, BuildContext context,
      [double height = 24, double width = 24])
      : super(
          icon: Image.asset(
            asset,
            color: Colors.grey,
            cacheWidth: MediaQuery.of(context).size.width.toInt(),
            width: width,
            height: height,
          ),
        );
}
