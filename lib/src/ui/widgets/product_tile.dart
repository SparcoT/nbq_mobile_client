import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/data/cart.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/ui/pages/product_detail_page.dart';
import 'package:nbq_mobile_client/src/ui/widgets/product_counter.dart';
import 'dart:ui' as ui;

class ProductTile extends StatefulWidget {
  final CartProduct product;
  final ProductDetailPageController controller;

  ProductTile({this.product, this.controller});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      widget.product.product.category == ProductCategory.caps
          ? Container(
              width: 60,
              height: 60,
              child: Image.asset(widget.product.product.ref,width: 100,),
            )
          : Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: widget.product.product.color,
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  widget.product.product.ref,
                  style: TextStyle(
                    fontFamily: 'Futura',
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    shadows: <Shadow>[
                      Shadow(
                        blurRadius: 3.0,
                        color: Colors.white,
                      ),
                      Shadow(
                        blurRadius: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          widget.product.product.name,
          style: TextStyle(fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      SizedBox(
        width: 185,
        child: Row(children: [
          Expanded(
            child: ProductQtyCounter(
              quantity: widget.product.cans ?? 0,
              onChanged: (val) {
                widget.product.cans = val;
                widget.controller.cansCount = val;

                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ProductQtyCounter(
              quantity: widget.product.packs ?? 0,
              onChanged: (val) {
                widget.product.packs = val;
                widget.controller.boxesCount = val;

                setState(() {});
              },
            ),
          ),
        ]),
      ),
      SizedBox(width: 10)
    ]);
  }
}
