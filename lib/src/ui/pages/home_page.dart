import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';
import 'package:nbq_mobile_client/src/ui/views/cart_view.dart';
import 'package:nbq_mobile_client/src/ui/views/products_view.dart';
import 'package:nbq_mobile_client/src/ui/views/contact_us_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/localization_selector.dart';
import 'package:url_launcher/url_launcher.dart';

import 'design-images_page.dart';

class HomePage extends StatelessWidget {
  final int initialIndex;

  HomePage({this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: initialIndex,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: LocalizationSelector(),
                ),
                Image.asset(Assets.logo, height: 45),
                SizedBox(
                  width: 60,
                  child: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      launch(
                          'https://play.google.com/store/apps/details?id=com.sparkosol.nbq');
                    },
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ProductsView(),
              DesignImages(),
              CartView(),
              ContactUsView()
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 10,
          child: TabBar(
            indicatorWeight: 2,
            indicatorColor: AppTheme.primaryColor,
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 17),
            tabs: [
              _NavBarTab(Assets.dropIcon),
              _NavBarTab(Assets.folderIcon),
              _NavBarTab(Assets.cartIcon),
              _NavBarTab(Assets.contactIcon),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarTab extends Tab {
  _NavBarTab(String asset)
      : super(
          icon: Image.asset(asset, color: Colors.grey, width: 24, height: 24),
        );
}
