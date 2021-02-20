import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/data/cart.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/ui/widgets/product_counter.dart';
import 'package:nbq_mobile_client/src/ui/widgets/product_tile.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductDetail detail;

  ProductDetailPage(this.detail);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String name;
  final Color color;
  final ValueChanged<int> onChanged;

  _ProductDetailPageAppBar({this.name, this.color, this.onChanged});

  @override
  __ProductDetailPageAppBarState createState() =>
      __ProductDetailPageAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(160);
}

class __ProductDetailPageAppBarState extends State<_ProductDetailPageAppBar> {
  var _group = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black38,
          blurRadius: 10,
        )
      ]),
      child: Column(
        children: [
          Text(
            widget.name,
            style: TextStyle(
              // color: 'Color',
              fontFamily: 'Futura',
              fontSize: 60,
            ),
          ),
          Spacer(),
          Row(children: [
            Container(
              width: 200,
              height: 35,
              margin: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  )
                ],
              ),
              child: Center(
                child: TextFormField(
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 13, bottom: 13, right: 13),
                      hintText: 'Search by reference number',
                      border: InputBorder.none),
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: 110,
              child: CupertinoSlidingSegmentedControl(
                groupValue: _group,
                children: {0: Text('Lata'), 1: Text('Pack')},
                onValueChanged: (val) {
                  setState(() {
                    _group = val;
                    widget.onChanged?.call(val);
                  });
                },
              ),
            ),
            SizedBox(width: 15),
          ]),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  var group = 0;
  List<CartProduct> products;

  int get cansCount => products.fold(0, (v, e) => v + e.cans);

  @override
  void initState() {
    super.initState();

    products = Product.all
        .where((e) => widget.detail.category == e.category)
        .map((e) => CartProduct(e))
        .toList(growable: false);
    products = products.length > 20 ? products.sublist(0, 20) : products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ProductDetailPageAppBar(
          name: widget.detail.name,
          onChanged: (val) => setState(() => group = val)),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 15),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) =>
            ColorTile(products[index], group == 0, () => setState(() {})),
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(height: 5),
      ),
      bottomNavigationBar: Container(
        height: 130,
        padding: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(children: [
              Spacer(),
              Text(
                'Total Latas',
                style: GoogleFonts.bebasNeue(
                  fontSize: 17,
                  fontWeight: FontWeight.w200,
                ),
              ),
              SizedBox(width: 15),
              Container(
                width: 105,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                    )
                  ],
                ),
                child: Center(child: Text(cansCount.toString())),
              ),
              SizedBox(width: 15),
            ]),
            SizedBox(height: 15),
            Row(children: [
              SizedBox(width: 30),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Cart().addAll(products.where(
                      (element) => element.cans > 0 || element.packs > 0)),
                  child: Text('Anadir'),
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    minimumSize: Size.fromHeight(40),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    print('here');
                  },
                  child: Text('Verpidedo'),
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
    );
  }
}

class ColorTile extends StatelessWidget {
  final bool isCans;
  final CartProduct product;
  final VoidCallback changed;

  ColorTile(this.product, this.isCans, this.changed);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Row(children: [
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
          Text(product.product.name, style: TextStyle(fontSize: 15)),
        ]),
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
