import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:nbq_mobile_client/src/data/cart.dart';
import 'package:nbq_mobile_client/src/data/data_manager.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/data/product.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:nbq_mobile_client/src/ui/widgets/category_tile.dart';
import 'package:nbq_mobile_client/src/ui/widgets/product_tile.dart';

import '../../app.dart';
import 'home_page.dart';

class ProductDetailPageController extends ChangeNotifier {
  int _cansCount = 0;
  int _boxesCount = 0;

  get cansCount => _cansCount;
  get boxesCount => _boxesCount;

  set cansCount(int value) {
    _cansCount = value;
    notifyListeners();
  }

  set boxesCount(int value) {
    _boxesCount = value;
    notifyListeners();
  }
}

class ProductDetailPage extends StatefulWidget {
  final $Category category;

  const ProductDetailPage(this.category) : super();

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Purchasable> products;
  List<Purchasable> viewedProducts = [];

  var _loading = true;
  final _controller = ProductDetailPageController();

  Future<void> _loadProducts() async {
    products = [];
    for (final item in widget.category.keys) {
      final product = await DataManager.loadSpray(widget.category.type, item);
      _controller.boxesCount += product.boxQty ?? 0;
      _controller.cansCount += product.singleQty ?? 0;

      products.add(product);
    }

    viewedProducts = List.from(products);
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();

    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (context, lang) => LayoutBuilder(builder: (_, constraints) {
        var parts = constraints.maxWidth ~/ 400;
        parts = parts > viewedProducts.length ? viewedProducts.length : parts;
        if (parts == 0) parts = 1;

        int length = widget.category.keys.length < viewedProducts.length
            ? widget.category.keys.length
            : viewedProducts.length;

        Widget child;
        if (_loading) {
          child = Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoActivityIndicator(),
                SizedBox(width: 10),
                Text('Loading Products')
              ],
            ),
          );
        } else if (parts == 1) {
          child = ListView.separated(
            itemCount: length,
            physics: BouncingScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(height: 5),
            padding: const EdgeInsets.symmetric(vertical: 15),
            itemBuilder: (_, i) => ProductTile(
              type: widget.category.type,
              product: viewedProducts[i],
              controller: _controller,
            ),
          );
        } else {
          child = Column(
            children: [
              Row(
                children: List.generate(
                  parts,
                  (index) => Expanded(
                      child: Align(
                    alignment: Alignment.centerRight,
                    child: CounterHeader(widget.category.type != 4),
                  )),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: parts,
                    childAspectRatio:
                        constraints.maxWidth / (30 * parts) - parts,
                  ),
                  itemBuilder: (_, i) => ProductTile(
                    type: widget.category.type,
                    product: viewedProducts[i],
                    controller: _controller,
                  ),
                  itemCount: length,
                ),
              ),
            ],
          );
        }

        return Scaffold(
          body: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: child,
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(165),
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 5,
              ),
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Row(
                          children: [
                            Transform.rotate(
                              angle: widget.category.type < 4 ? -1.56: 0,
                              child: Image.asset(
                                widget.category.image,
                                height: 109,
                              ),
                            ),
                            Text(
                              widget.category.name,
                              style: TextStyle(
                                color: widget.category.color,
                                fontFamily: 'Futura',
                                fontSize: 60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_loading)
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0, right: 10),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              child: Text('Reset'),
                              onPressed: _onReset,
                            ),
                          ),
                        ),
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(children: [
                    if (!_loading)
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            onChanged: _onSearched,
                            onFieldSubmitted: _onSearched,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              contentPadding: const EdgeInsets.all(10),
                              hintText: lang.searchByReference,
                              hintStyle: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    if (parts == 1) CounterHeader(widget.category.type != 4),
                  ]),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _loading
              ? null
              : _PageBottom(lang: lang, controller: _controller),
        );
      }),
    );
  }

  void _onSearched(String val) {
    viewedProducts = List.from(
      products.where(
        (e) => (e.ref.contains(val.toUpperCase()) ||
            e.name.toLowerCase().contains(val.toLowerCase())),
      ),
    );
    setState(() {});
  }

  void _onReset() {
    DataManager.clearAllSelection(widget.category.type);

    products.forEach((element) {
      if ((element.singleQty ?? 0) > 0 || (element.boxQty ?? 0) > 0) {
        element.singleQty = element.boxQty = 0;
        element.save();
      }
    });

    _controller.cansCount = 0;
    _controller.boxesCount = 0;

    setState(() {});
  }
}

class _PageBottom extends StatefulWidget {
  final dynamic lang;
  final ProductDetailPageController controller;

  const _PageBottom({this.lang, this.controller, Key key}) : super(key: key);

  @override
  __PageBottomState createState() => __PageBottomState();
}

class __PageBottomState extends State<_PageBottom> {
  void _rebuild() => setState(() {});

  @override
  void initState() {
    widget.controller.addListener(_rebuild);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.lang;

    return Container(
      height: 130,
      padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(children: [
        Row(
          children: [
            Spacer(),
            Text(
              lang.totalPacks,
              style: GoogleFonts.bebasNeue(fontSize: 17),
            ),
            SizedBox(width: 15),
            Container(
              width: 55,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child:
                  Center(child: Text(widget.controller._boxesCount.toString())),
            ),
            SizedBox(width: 15),
            Text(
              lang.totalCans,
              style: GoogleFonts.bebasNeue(fontSize: 17),
            ),
            SizedBox(width: 15),
            Container(
              width: 55,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child:
                  Center(child: Text(widget.controller._cansCount.toString())),
            ),
            SizedBox(width: 15),
          ],
        ),
        SizedBox(height: 15),
        Row(children: [
          Spacer(),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 1.2),
            child: Row(children: [
              Spacer(flex: 5),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    HomePageState.tabController.animateTo(3);
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
            ]),
          )
        ], mainAxisAlignment: MainAxisAlignment.center),
      ]),
    );
  }
}

class CounterHeader extends Container {
  CounterHeader([bool flag = true])
      : super(
          width: 195,
          height: 30,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(child: Center(child: Text(flag ? 'Can' : 'x1'))),
              VerticalDivider(indent: 7, endIndent: 7, thickness: 1, width: 1),
              Expanded(child: Center(child: Text(flag ? 'Box' : 'x100')))
            ],
          ),
        );
}
