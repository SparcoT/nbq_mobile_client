import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/ui/widgets/category_tile.dart';

class ProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
                mainAxisSpacing: 40,crossAxisSpacing: 40,childAspectRatio: 2/0.6
            ),
            children: [
              CategoryTile.slow(),
              CategoryTile.fast(),
              CategoryTile.wtf(),
              CategoryTile.pro(),
            ],
          )
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              CategoryTile.slow(),
              CategoryTile.fast(),
              CategoryTile.wtf(),
              CategoryTile.pro(),
            ]),
          );
  }
}
