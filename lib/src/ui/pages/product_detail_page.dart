import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/data/cart.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/product_tile.dart';
import 'package:nbq_mobile_client/src/ui/widgets/category_tile.dart';

class ProductDetailPage extends StatefulWidget {
  final Category category;

  ProductDetailPage(this.category);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final Category category;
  final ValueChanged<int> onChanged;
  final ValueChanged<String> onSearched;

  _ProductDetailPageAppBar({
    this.category,
    this.onChanged,
    this.onSearched,
  });

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
    return LocalizedView(
      builder: (context, lang) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
          )
        ]),
        child: Column(
          children: [
            Row(children: [
              Transform.rotate(
                angle: -1.56,
                child: Image.asset(widget.category.image, height: 109,),
              ),
              Text(
                widget.category.name,
                style: TextStyle(
                  color: widget.category.color,
                  fontFamily: 'Futura',
                  fontSize: 60,
                ),
              ),
            ]),
            Spacer(),
            Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoSearchTextField(
                    placeholderStyle: TextStyle(fontSize: 14),
                    placeholder: 'Search by Reference #',
                    onChanged: widget.onSearched,
                    onSubmitted: widget.onSearched,
                  ),
                ),
              ),
              SizedBox(
                width: 110,
                child: CupertinoSlidingSegmentedControl(
                  groupValue: _group,
                  children: {0: Text(lang.can), 1: Text(lang.pack)},
                  onValueChanged: (val) => setState(() {
                    _group = val;
                    widget.onChanged?.call(val);
                  }),
                ),
              ),
              SizedBox(width: 15),
            ]),
            SizedBox(height: 15),
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

  @override
  void initState() {
    super.initState();

    products = Product.all
        .where((e) => widget.category.category == e.category)
        .map((e) => CartProduct(e))
        .toList(growable: false);
    viewedProducts = List.from(products);
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => Scaffold(
        appBar: _ProductDetailPageAppBar(
          category: widget.category,
          onSearched: (val) {
            viewedProducts = List.from(products
                .where((e) => e.product.ref.startsWith(val.toUpperCase())));
            setState(() {});
          },
          onChanged: (val) => setState(() => group = val),
        ),
        body: ListView.separated(
          itemCount: viewedProducts.length,
          physics: BouncingScrollPhysics(),
          separatorBuilder: (_, __) => SizedBox(height: 5),
          padding: const EdgeInsets.symmetric(vertical: 15),
          itemBuilder: (_, i) =>
              ProductTile(viewedProducts[i], group == 0, () => setState(() {})),
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
                  lang.totalCans,
                  style: GoogleFonts.bebasNeue(fontSize: 17),
                ),
                SizedBox(width: 15),
                Container(
                  width: 105,
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
              ]),
              SizedBox(height: 15),
              Row(children: [
                SizedBox(width: 30),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Cart().addAll(products.where(
                      (element) => element.cans > 0 || element.packs > 0,
                    )),
                    child: Text(lang.add),
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
    );
  }
}
