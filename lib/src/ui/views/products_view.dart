import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/ui/widgets/product_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';

class ProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ProductTile.slow(),
        ProductTile.fast(),
        ProductTile.wtf(),
        ProductTile.pro(),
      ]),
    );
  }
}

class InfoBox extends Container {
  InfoBox(String info)
      : super(
          width: 45,
          height: 25,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  color: Colors.grey.shade300,
                )
              ]),
          child: Center(child: Text(info)),
        );
}
