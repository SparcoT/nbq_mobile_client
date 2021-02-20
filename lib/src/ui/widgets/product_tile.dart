import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';
import 'package:nbq_mobile_client/src/data/models/db.dart';
import 'package:nbq_mobile_client/src/ui/pages/product_detail_page.dart';

class _ProductDetail {
  final String name;
  final Color color;
  final String image;
  final double width;
  final Offset offset;
  final ProductCategory category;

  const _ProductDetail({
    this.category,
    this.name,
    this.color,
    this.offset,
    this.image,
    this.width,
  });
}

class ProductTile extends StatelessWidget {
  final _ProductDetail _detail;

  const ProductTile.slow()
      : _detail = const _ProductDetail(
          width: 130,
          name: 'SLOW',
          image: Assets.nbqSlow,
          offset: Offset(25, 16),
          color: AppTheme.colorOfSlow,
          category: ProductCategory.slow,
        );

  const ProductTile.fast()
      : _detail = const _ProductDetail(
          width: 167,
          name: 'FAST',
          offset: Offset(-4.55, -28.5),
          image: Assets.nbqFast,
          color: AppTheme.colorOfFast,
          category: ProductCategory.fast,
        );

  const ProductTile.wtf()
      : _detail = const _ProductDetail(
          width: 167,
          name: 'WTF',
          offset: Offset(-4.55, 7.5),
          image: Assets.nbqWTF,
          color: AppTheme.colorOfWTF,
          category: ProductCategory.wtf,
        );

  const ProductTile.pro()
      : _detail = const _ProductDetail(
          width: 161,
          name: 'PRO',
          offset: Offset(7, 16),
          image: Assets.nbqPropulse,
          color: AppTheme.colorOfPropulse,
          category: ProductCategory.pro,
        );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 45),
      child: TextButton(
        onPressed: () {
          AppNavigation.navigateTo(context, ProductDetailPage());
        },
        style: TextButton.styleFrom(
          primary: _detail.color,
          padding: EdgeInsets.zero,
          shape: BeveledRectangleBorder(),
          minimumSize: Size.fromHeight(90),
          backgroundColor: Colors.transparent,
        ),
        child: Row(children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 130,
                height: 90,
                decoration: BoxDecoration(
                  color: Color(0xFFE9E9E9),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(10),
                  ),
                ),
              ),
              Positioned(
                top: _detail.offset.dy,
                left: _detail.offset.dx,
                child: Image.asset(_detail.image, width: _detail.width),
              )
            ],
          ),
          SizedBox(width: 30),
          Column(children: [
            Text(
              _detail.name,
              style: TextStyle(
                fontFamily: 'Futura',
                fontSize: 42,
              ),
            ),
            Text(
              Product.all
                      .where((element) => element.category == _detail.category)
                      .length
                      .toString() +
                  ' Colors',
              style: GoogleFonts.bebasNeue(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ], crossAxisAlignment: CrossAxisAlignment.start),
        ]),
      ),
    );
  }
}
