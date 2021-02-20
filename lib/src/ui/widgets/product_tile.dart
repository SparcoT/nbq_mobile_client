import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/data/cart.dart';
import 'package:nbq_mobile_client/src/ui/widgets/product_counter.dart';

class ProductTile extends StatelessWidget {
  final bool isCans;
  final CartProduct product;
  final VoidCallback changed;

  ProductTile(this.product, this.isCans, this.changed);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: product.product.color,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SizedBox(
          width: 35,
          child: Text(
            product.product.ref,
            style: TextStyle(
              fontFamily: 'Futura',
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      Expanded(
        child: Text(product.product.name, style: TextStyle(fontSize: 15)),
      ),
      AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.all(2),
          child: ProductQtyCounter(onChanged: (val) {
            product.cans = val;
            changed();
          }),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.all(2),
          child: ProductQtyCounter(onChanged: (val) {
            product.packs = val;
            changed();
          }),
        ),
        crossFadeState:
        isCans ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 500),
      ),
      SizedBox(width: 15),
    ]);
  }
}
