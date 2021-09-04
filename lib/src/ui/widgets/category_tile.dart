import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/data/data_manager.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';
import 'package:nbq_mobile_client/src/ui/pages/product_detail_page.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';

class $Category {
  final int type;
  final String name;
  final String subTitle;
  final Color color;
  final String image;
  final double width;
  final Offset offset;
  final Iterable<dynamic> keys;

  const $Category._({
    this.type,
    this.keys,
    this.name,
    this.color,
    this.offset,
    this.image,
    this.width,
    this.subTitle = '',
  });
}

class CategoryTile extends StatelessWidget {
  final $Category _detail;

  CategoryTile.slow(String subTitle)
      : _detail = $Category._(
          type: 0,
          width: 130,
          name: 'SLOW',
          subTitle: subTitle,
          image: Assets.nbqSlow,
          offset: Offset(25, 16),
          color: AppTheme.colorOfSlow,
          keys: DataManager.slowSprays,
        );

  CategoryTile.fast(String subTitle)
      : _detail = $Category._(
          type: 1,
          width: 167,
          name: 'FAST',
          subTitle: subTitle,
          offset: Offset(-4.55, -28.5),
          image: Assets.nbqFast,
          color: AppTheme.colorOfFast,
          keys: DataManager.fastSprays,
        );

  CategoryTile.wtf(String subTitle)
      : _detail = $Category._(
          type: 2,
          width: 167,
          name: 'WTF',
          subTitle: subTitle,
          offset: Offset(-4.55, 7.5),
          image: Assets.nbqWTF,
          color: AppTheme.colorOfWTF,
          keys: DataManager.wtfSprays,
        );

  CategoryTile.pro(String subTitle)
      : _detail = $Category._(
          type: 3,
          width: 161,
          name: 'PRO',
          subTitle: subTitle,
          offset: Offset(7, 16),
          image: Assets.nbqPropulse,
          color: AppTheme.colorOfPropulse,
          keys: DataManager.proSprays,
        );

  CategoryTile.caps()
      : _detail = $Category._(
          type: 4,
          width: 200,
          name: 'CAPS',
          offset: Offset(7, -10),
          image: Assets.redN3Cap,
          color: AppTheme.colorOfPropulse,
          keys: DataManager.caps,
        );

  CategoryTile.displays()
      : _detail = $Category._(
          type: 5,
          width: 90,
          name: 'DISPLAYS',
          offset: Offset(57, 5),
          image: Assets.nbqDisplay,
          color: AppTheme.colorOfPropulse,
          keys: DataManager.displays,
        );

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? LocalizedView(
            builder: (ctx, lang) => Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: TextButton(
                onPressed: () {
                  // Navigator.of(context).pushNamed('/products', arguments: _detail);
                  AppNavigation.navigateTo(context, ProductDetailPage(_detail));
                },
                style: TextButton.styleFrom(
                  primary: _detail.color,
                  padding: EdgeInsets.zero,
                  shape: BeveledRectangleBorder(),
                  minimumSize: Size.fromHeight(90),
                  backgroundColor: Colors.transparent,
                ),
                child: Row(children: [
                  Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xFFE9E9E9),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(10),
                      ),
                    ),
                    child: Image.asset(_detail.image, width: _detail.width),
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      Text(
                        _detail.name,
                        style: TextStyle(fontFamily: 'Futura', fontSize: 42),
                      ),
                      if (_detail.subTitle.isNotEmpty)
                        Text(
                          _detail.subTitle,
                          style: GoogleFonts.bebasNeue(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ]),
              ),
            ),
          )
        : LocalizedView(
            builder: (ctx, lang) => Padding(
              padding: const EdgeInsets.only(bottom: 45),
              child: TextButton(
                onPressed: () {
                  // Navigator.of(context).pushNamed('/products', arguments: _detail);
                  AppNavigation.navigateTo(context, ProductDetailPage(_detail));
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
                      style: TextStyle(fontFamily: 'Futura', fontSize: 42),
                    ),
                    if (_detail.subTitle.isNotEmpty)
                      Text(
                        _detail.subTitle,
                        style: GoogleFonts.bebasNeue(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    Text(
                      ' ${lang.colors} ${DataManager.getCount(_detail.type)}',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ], crossAxisAlignment: CrossAxisAlignment.start),
                ]),
              ),
            ),
          );
  }
}
