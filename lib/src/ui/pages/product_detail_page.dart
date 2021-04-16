import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/data/cart.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/product_tile.dart';
import 'package:nbq_mobile_client/src/ui/widgets/category_tile.dart';
import '../../app.dart';
import '../../data/cart.dart';
import 'home_page.dart';

class ProductDetailPage extends StatefulWidget {
  final $Category category;

  ProductDetailPage(this.category);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final $Category category;
  final ValueChanged<int> onChanged;
  final ValueChanged<String> onSearched;
  final Function onReset;
  final packCount, cansCount;

  _ProductDetailPageAppBar({
    this.category,
    this.onChanged,
    this.onSearched,
    this.onReset,
    this.cansCount,
    this.packCount,
  });

  @override
  __ProductDetailPageAppBarState createState() =>
      __ProductDetailPageAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(160);
}

class __ProductDetailPageAppBarState extends State<_ProductDetailPageAppBar> {
  var _group = 0;
  List<CartProduct> products;

  // List<CartProduct> viewedProducts;
  //
  // int get cansCount => products.fold(0, (v, e) => v + e.cans);
  //
  // int get packsCount => products.fold(0, (v, e) => v + e.packs);
  //
  // void initState() {
  //   super.initState();
  //   products = Product.all
  //       .where((e) => widget.category.category == e.category)
  //       .map((e) => CartProduct(e))
  //       .toList(growable: false);
  //   if (Cart().products.isNotEmpty) {
  //     final rs = Cart()
  //         .products
  //         .where(
  //             (element) => element.product.category == widget.category.category)
  //         .toList();
  //     print(rs.length);
  //     rs.forEach((element) {
  //       products.forEach((element1) {
  //         if (element.product.ref == element1.product.ref) {
  //           print('Match');
  //           element1.cans = element.cans;
  //           element1.packs = element.packs;
  //         }
  //       });
  //     });
  //   }
  //   viewedProducts = List.from(products);
  // }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5),
        decoration: BoxDecoration(
          borderRadius: kIsWeb
              ? BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
              : null,
          color: Colors.white,

        ),
        child: Column(
          children: [
            Stack(
              children: [
                if (!kIsWeb)
                  if (Platform.isIOS)
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                Padding(
                  padding: EdgeInsets.only(
                    left: kIsWeb
                        ? 0
                        : Platform.isIOS
                            ? 40
                            : 0,
                  ),
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: -1.56,
                        child: Image.asset(
                          widget.category.image,
                          height: 109,
                        ),
                      ),
                      Text(
                        widget.category.name,
                        style: TextStyle(
                          color: widget.category.color,
                          fontFamily: 'Futura',
                          fontSize: 60,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, right: 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: Text('Reset'),
                      onPressed: () {
                        widget.onReset();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoTextField(
                    placeholderStyle: TextStyle(fontSize: 14),
                    placeholder: lang.searchByReference,
                    onChanged: widget.onSearched,
                    onSubmitted: widget.onSearched,
                  ),
                ),
              ),
              SizedBox(
                width: 110,
                child: CupertinoSlidingSegmentedControl(
                  groupValue: _group,
                  children: {0: Text(lang.can), 1: Text(lang.box)},
                  onValueChanged: (val) => setState(() {
                    _group = val;
                    widget.onChanged?.call(val);
                  }),
                ),
              ),
              SizedBox(width: 15),
            ]),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  var group = 0;
  List<CartProduct> products;
  List<CartProduct> viewedProducts;

  int get cansCount => products.fold(0, (v, e) => v + e.cans);

  int get packsCount => products.fold(0, (v, e) => v + e.packs);

  @override
  void initState() {
    super.initState();
    products = Product.all
        .where((e) => widget.category.category == e.category)
        .map((e) => CartProduct(e))
        .toList(growable: false);
    if (Cart().products.isNotEmpty) {
      final rs = Cart()
          .products
          .where(
              (element) => element.product.category == widget.category.category)
          .toList();
      print(rs.length);
      rs.forEach((element) {
        products.forEach((element1) {
          if (element.product.ref == element1.product.ref) {
            print('Match');
            element1.cans = element.cans;
            element1.packs = element.packs;
          }
        });
      });
    }
    viewedProducts = List.from(products);
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => Padding(
        padding: kIsWeb
            ? const EdgeInsets.symmetric(horizontal: 0, vertical: 4)
            : EdgeInsets.zero,
        child: Scaffold(
          appBar: _ProductDetailPageAppBar(
            cansCount: cansCount,
            packCount: packsCount,
            onReset: () {
              if (Cart().products.isNotEmpty) {
                final rs = Cart()
                    .products
                    .where((element) =>
                        element.product.category == widget.category.category)
                    .toList();
                rs.forEach((element) {
                  Cart().products.remove(element);
                });
              }
              viewedProducts.forEach((element) {
                element.packs = 0;
                element.cans = 0;
              });
              setState(() {});
            },
            category: widget.category,
            onSearched: (val) {
              viewedProducts = List.from(
                products.where(
                  (e) => (e.product.ref.contains(val.toUpperCase()) ||
                      e.product.name.toLowerCase().contains(val.toLowerCase())),
                ),
              );
              setState(() {});
            },
            onChanged: (val) => setState(() => group = val),
          ),
          body: kIsWeb
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 2 / 0.2),
                  itemBuilder: (_, i) => ProductTile(
                      viewedProducts[i], group == 0, () => setState(() {})),
                  itemCount: viewedProducts.length,
                )
              : ListView.separated(
                  itemCount: viewedProducts.length,
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (_, __) => SizedBox(height: 5),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  itemBuilder: (_, i) => ProductTile(
                      viewedProducts[i], group == 0, () => setState(() {})),
                ),
          bottomNavigationBar: Container(
            height: kIsWeb ? 110 : 130,
            padding: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    Text(
                      lang.totalPacks,
                      style: GoogleFonts.bebasNeue(fontSize: 17),
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: 55,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4)
                        ],
                      ),
                      child: Center(child: Text(packsCount.toString())),
                    ),
                    SizedBox(width: 15),
                    Text(
                      lang.totalCans,
                      style: GoogleFonts.bebasNeue(fontSize: 17),
                    ),
                    SizedBox(width: 15),
                    Container(
                      width: 55,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4)
                        ],
                      ),
                      child: Center(child: Text(cansCount.toString())),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
                SizedBox(height: 15),
                Row(children: [
                  SizedBox(width: 30),
                  Expanded(
                    child: Builder(
                      builder: (ctx) => ElevatedButton(
                        onPressed: () async {
                          Cart().addAll(products.where(
                            (element) => element.cans > 0 || element.packs > 0,
                          ));
                          if (products.any((element) =>
                              element.cans > 0 || element.packs > 0))
                            ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(content: Text(lang.addedToCart)));
                        },
                        child: Text(lang.add),
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          minimumSize: Size.fromHeight(40),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        HomePageState.tabController.animateTo(3);
                        // AppNavigation.navigateTo(
                        //     context,
                        //     HomePage(
                        //       initialIndex: 2,
                        //     ));
                      },
                      child: Text(lang.seeOrder),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        primary: Colors.black,
                        onPrimary: AppTheme.primaryColor,
                        minimumSize: Size.fromHeight(40),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                ], mainAxisAlignment: MainAxisAlignment.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
