import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/category_tile.dart';

class ProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) {
        return kIsWeb
            ? GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 40,
                    crossAxisSpacing: 40,
                    childAspectRatio: 2 / 0.6),
                children: [
                  CategoryTile.slow(lang.slowSubTitle),
                  CategoryTile.fast(lang.fastSubTitle),
                  // CategoryTile.wtf(),
                  CategoryTile.pro(lang.proSubTitle),
                  CategoryTile.caps(),
                  CategoryTile.displays(),
                ],
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(children: [
                  CategoryTile.slow(lang.slowSubTitle),
                  CategoryTile.fast(lang.fastSubTitle),
                  // CategoryTile.wtf(),
                  CategoryTile.pro(lang.proSubTitle),
                  CategoryTile.caps(),
                  CategoryTile.displays(),
                ]),
              );
      },
    );
  }
}
