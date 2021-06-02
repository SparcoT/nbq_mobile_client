import 'package:hive/hive.dart';

import '../../utils/pdf_share.dart'
    if (dart.library.io) '../../utils/pdf_share_io.dart'
    if (dart.library.html) '../../utils/pdf_share_html.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/data/cart.dart';
import 'package:nbq_mobile_client/src/base/assets.dart';
import 'package:nbq_mobile_client/src/data/order_data.dart';
import 'package:nbq_mobile_client/src/ui/widgets/text_field.dart';
import 'package:nbq_mobile_client/src/ui/widgets/shadowed_box.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  var _loading = true;
  var isHeaderBuilt = false;

  final _wtfProducts = <CartProduct>[];
  final _proProducts = <CartProduct>[];
  final _slowProducts = <CartProduct>[];
  final _fastProducts = <CartProduct>[];
  LazyBox<CartProduct> _cart;

  final _data = OrderData();

  AutovalidateMode _mode = AutovalidateMode.disabled;

  var _cans = 0;
  var _packs = 0;

  Future<void> _loadProducts() async {
    _cart = Hive.lazyBox<CartProduct>('cart_products');

    for (final key in _cart.keys) {
      final char = key[0];
      final element = await _cart.get(key);

      if (char == '0') {
        _slowProducts.add(element);
      } else if (char == '1') {
        _fastProducts.add(element);
      } else if (char == '2') {
        _wtfProducts.add(element);
      } else if (char == '3') {
        _proProducts.add(element);
      }

      _cans += element.cans;
      _packs += element.cans;
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(),
            SizedBox(width: 10),
            Text('Loading Cart'),
          ],
        ),
      );
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .2),
            blurRadius: 10,
          )],
        ),
        constraints: BoxConstraints(maxWidth: 700),
        child: Form(
          key: _formKey,
          autovalidateMode: _mode,
          child: LocalizedView(
            builder: (context, lang) => CustomScrollView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 15)),
                if (_cart.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            await _cart.clear();

                            setState(() {
                              _slowProducts.clear();
                              _fastProducts.clear();
                              _wtfProducts.clear();
                              _proProducts.clear();
                            });
                          },
                          icon: Icon(
                            CupertinoIcons.trash,
                            size: 15,
                          ),
                          label: Text(
                            'Clear',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_slowProducts.isNotEmpty) ...[
                  SliverToBoxAdapter(child: _buildHeader('SLOW')),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ColorTile(_slowProducts[index]),
                      ),
                      childCount: _slowProducts.length,
                    ),
                  ),
                ],
                if (_fastProducts.isNotEmpty) ...[
                  SliverToBoxAdapter(child: _buildHeader('FAST')),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ColorTile(_fastProducts[index]),
                      ),
                      childCount: _fastProducts.length,
                    ),
                  ),
                ],
                if (_wtfProducts.isNotEmpty) ...[
                  SliverToBoxAdapter(child: _buildHeader('WTF')),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ColorTile(_wtfProducts[index]),
                      ),
                      childCount: _wtfProducts.length,
                    ),
                  ),
                ],
                if (_proProducts.isNotEmpty) ...[
                  SliverToBoxAdapter(child: _buildHeader('PRO')),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ColorTile(_proProducts[index]),
                      ),
                      childCount: _proProducts.length,
                    ),
                  ),
                ],
                if (_cart.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                    sliver: SliverToBoxAdapter(
                        child: AppTextField(
                      label: lang.name,
                      // validator: Validators.required,
                      onSaved: (val) => _data.name = val,
                    )),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    sliver: SliverToBoxAdapter(
                        child: AppTextField(
                      label: lang.email,
                      keyboardType: TextInputType.emailAddress,
                      // validator: (val) => emailValidator(val),
                      onSaved: (val) => _data.email = val,
                    )),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    sliver: SliverToBoxAdapter(
                      child: AppTextField(
                        label: lang.telephone,
                        keyboardType: TextInputType.phone,
                        // validator: Validators.required,
                        onSaved: (val) => _data.contact = val,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    sliver: SliverToBoxAdapter(
                      child: AppTextField(
                        maxLines: 3,
                        label: "Note",
                        // validator: Validators.required,
                        onSaved: (val) => _data.note = val,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
                    sliver: SliverToBoxAdapter(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            setState(() {
                              _mode = AutovalidateMode.always;
                            });
                            return;
                          }
                          _formKey.currentState.save();
                          await _generatePdf();
                        },
                        child: Text(kIsWeb ? "DOWNLOAD" : lang.sendOrShare),
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: Colors.black,
                          onPrimary: AppTheme.primaryColor,
                          minimumSize: Size.fromHeight(40),
                        ),
                      ),
                    ),
                  ),
                ] else
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        lang.noProducts,
                        style: TextStyle(fontSize: 20, fontFamily: 'Futura'),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // pw.Table _generateTable(List<CartProduct> products) {
  //   return ;
  // }
  _generatePdf() async {
    final document = pw.Document();
    final _image = (await rootBundle.load(Assets.logo)).buffer.asUint8List();
    var _totalCans = 0;
    var _totalPacks = 0;
    if (_slowProducts.isNotEmpty) {
      _slowProducts.forEach((element) {
        _totalCans += element.cans;
        _totalPacks += element.packs;
      });
      _slowProducts.sort((first, second) {
        return first.product.sku.toInt() - second.product.sku.toInt();
      });
    }
    if (_fastProducts.isNotEmpty) {
      _fastProducts.forEach((element) {
        _totalCans += element.cans;
        _totalPacks += element.packs;
      });
      _fastProducts.sort((first, second) {
        return first.product.sku.toInt() - second.product.sku.toInt();
      });
    }
    if (_wtfProducts.isNotEmpty) {
      _wtfProducts.forEach((element) {
        _totalCans += element.cans;
        _totalPacks += element.packs;
      });
      _wtfProducts.sort((first, second) {
        return int.parse(first.product.ref.substring(1)) -
            int.parse(second.product.ref.substring(1));
        // return first.product?.sku?.toInt() ??
        //     0 - second.product?.sku?.toInt() ??
        //     0;
      });
    }
    if (_proProducts.isNotEmpty) {
      _proProducts.forEach((element) {
        _totalCans += element.cans;
        _totalPacks += element.packs;
      });
      _proProducts.sort((first, second) {
        return first.product.sku.toInt() - second.product.sku.toInt();
      });
    }

    var products = [
      if (_slowProducts.isNotEmpty) ...['SLOW', ..._slowProducts],
      if (_fastProducts.isNotEmpty) ...['FAST', ..._fastProducts],
      if (_wtfProducts.isNotEmpty) ...['WTF', ..._wtfProducts],
      if (_proProducts.isNotEmpty) ...['PRO', ..._proProducts]
    ];

    List<pw.Widget> page = [];
    List<pw.TableRow> rows = [];
    List<List<pw.Widget>> widgets = [];

    for (var i = 0; i < products.length; ++i) {
      if (i % 35 == 0) {
        page = [];
        rows = [];
        widgets.add(page);
      }

      if (products[i] is String) {
        if (rows.isNotEmpty) rows = [];
        page.add(pw.Text(
          products[i],
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ));
      } else {
        final dynamic e = products[i];
        if (rows.isEmpty) {
          rows.add(pw.TableRow(children: [
            pw.Text(
              ' Color',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              ' Ref',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              ' Sku',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              ' Name',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              ' Cans',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              ' Packs',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            )
          ]));
          page.add(pw.Table(
            children: rows,
            border: pw.TableBorder.all(color: PdfColors.black),
            columnWidths: {
              0: pw.FixedColumnWidth(40),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(3),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(1),
            },
          ));
        }

        rows.add(pw.TableRow(
          children: [
            pw.Container(
              height: 14,
              color: PdfColor.fromInt(e.product.color.value),
            ),
            pw.Text(' ' + e.product.ref),
            pw.Text(
              ' ' +
                  (e.product.sku == null
                      ? ''
                      : e.product.sku.toInt().toString()),
            ),
            pw.Text(' ' + e.product.name),
            pw.Text(' ' + e.cans.toString()),
            pw.Text(' ' + e.packs.toString())
          ],
        ));
      }
    }
    for (int i = 0; i < widgets.length; i++) {
      // for (final page in widgets) {
      document.addPage(pw.Page(build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.RichText(
                    text: pw.TextSpan(
                      text: 'Name: ',
                      children: [pw.TextSpan(text: _data.name)],
                    ),
                  ),
                  pw.RichText(
                    text: pw.TextSpan(
                      text: 'Email: ',
                      children: [pw.TextSpan(text: _data.email)],
                    ),
                  ),
                  pw.RichText(
                    text: pw.TextSpan(
                      text: 'Phone: ',
                      children: [pw.TextSpan(text: _data.contact)],
                    ),
                  ),
                  pw.RichText(
                    text: pw.TextSpan(
                      text: 'Note: ',
                      children: [pw.TextSpan(text: _data.note)],
                    ),
                  ),
                ],
              ),
              pw.Spacer(),
              pw.Column(children: [
                pw.Image(pw.MemoryImage(_image), width: 50, height: 20),
                pw.Text('NBQ Spray Company'),
              ]),
            ]),
            pw.Divider(),
            ...widgets[i],
            if (i == widgets.length - 1) ...[
              pw.SizedBox(height: 10),
              pw.Table(
                children: <pw.TableRow>[
                  pw.TableRow(
                    children: [
                      pw.Text(
                        'Total',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '$_totalCans',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '$_totalPacks',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
                columnWidths: {
                  0: pw.FlexColumnWidth(5.8),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(1),
                },
              ),
            ]
          ],
        );
      }));
    }

    sharePDF(document);
  }

  Widget _buildHeader(String text) {
    final header =
        Text(text, style: TextStyle(fontFamily: 'Futura', fontSize: 30));

    if (isHeaderBuilt) {
      return Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 10),
        child: header,
      );
    } else {
      isHeaderBuilt = true;
      return Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 10),
        child: Row(
          children: [
            Expanded(child: header),
            ShadowedBox(
                width: 50,
                height: 20,
                borderRadius: 6,
                child: Center(child: Text('Lata'))),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 10),
              child: ShadowedBox(
                width: 50,
                height: 20,
                borderRadius: 6,
                child: Center(child: Text('Pack')),
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      );
    }
  }
}

class ColorTile extends StatelessWidget {
  final CartProduct product;

  ColorTile(this.product);

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
      ShadowedBox(
        width: 50,
        height: 20,
        borderRadius: 6,
        child: Center(
          child: Text(product.cans.toString(), style: TextStyle(fontSize: 12)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 15, left: 10),
        child: ShadowedBox(
          width: 50,
          height: 20,
          borderRadius: 6,
          child: Center(
            child: Text(
              product.packs.toString(),
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    ]);
  }
}
