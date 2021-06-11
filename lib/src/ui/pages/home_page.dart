import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';
import 'package:nbq_mobile_client/src/data/db.g.g.dart';
import 'package:nbq_mobile_client/src/ui/views/cart_view.dart';
import 'package:nbq_mobile_client/src/ui/views/home_view.dart';
import 'package:nbq_mobile_client/src/ui/views/products_view.dart';
import 'package:nbq_mobile_client/src/ui/views/contact_us_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/localization_selector.dart';

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
    _configureFcm();
    tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
  }

  _configureFcm() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification.body}');
        _showNotificationDialog(message.notification);
      }
    });
  }

  _showNotificationDialog(RemoteNotification notification) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(notification.title),
            content: Text(notification.body),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget bottom;
        List<Widget> appBar;

        if (constraints.maxWidth < 700) {
          bottom = BottomAppBar(
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
          );
          appBar = [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: LocalizationSelector(),
            ),
            Expanded(
              child: Image.asset(Assets.logo, height: 45, cacheHeight: 45),
            ),
            if (kIsWeb)
              SizedBox(width: 60)
            else
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
        } else {
          appBar = [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: LocalizationSelector(),
            ),
            SizedBox(width: 100),
            Image.asset(Assets.logo, height: 45),
            SizedBox(width: 100),
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
          ];
        }

        final topPadding = MediaQuery.of(context).padding.top + 15;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56 + topPadding),
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Row(children: appBar),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: TabBarView(
              controller: tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                HomeView(),
                ProductsView(),
                DesignImages(),
                CartView(),
                ContactUsView(),
              ],
            ),
          ),
          bottomNavigationBar: bottom,
        );
      },
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
