import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/data/product.dart';
import 'package:nbq_mobile_client/src/data/data_manager.dart';
import 'package:nbq_mobile_client/src/ui/widgets/product_counter.dart';
import 'package:nbq_mobile_client/src/ui/pages/product_detail_page.dart';

class ProductTile extends StatefulWidget {
  final int type;
  final Purchasable product;
  final ProductDetailPageController controller;

  ProductTile({this.product, this.controller, this.type});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.product == null) {
      return SizedBox();
    }
    return Row(children: [
      widget.product is Cap
          ? Image.asset((widget.product as Cap).image, width: 100)
          : Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: (widget.product as Spray).color,
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
                  widget.product.ref,
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
          widget.product.name,
          style: TextStyle(fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      SizedBox(
        width: 195,
        child: Row(children: [
          Expanded(
            child: ProductQtyCounter(
              quantity: widget.product.singleQty ?? 0,
              onChanged: (val) {
                widget.product.singleQty = val;
                _updateDBCounter(widget.product);

                setState(() {});
              },
              onIncrement: () => widget.controller.cansCount += 1,
              onDecrement: () => widget.controller.cansCount -= 1,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ProductQtyCounter(
              quantity: widget.product.boxQty ?? 0,
              onChanged: (val) {
                widget.product.boxQty = val;
                _updateDBCounter(widget.product);

                setState(() {});
              },
              onIncrement: () => widget.controller.boxesCount += 1,
              onDecrement: () => widget.controller.boxesCount -= 1,
            ),
          ),
        ]),
      ),
      SizedBox(width: 10)
    ]);
  }

  Future<void> _updateDBCounter(Purchasable purchasable) async {
    await purchasable.save();
    if (purchasable.singleQty == 0 && purchasable.boxQty == 0) {
      DataManager.removeFromCartSelection(widget.type, purchasable.id);
    } else {
      print('ADDING TO CART: ${widget.type}');
      print('ADDING TO CART: ${purchasable.id}');
      DataManager.addToCart(widget.type, purchasable.id);
    }
  }
}
