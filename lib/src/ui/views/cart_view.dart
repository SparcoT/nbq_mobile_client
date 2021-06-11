import 'package:hive/hive.dart';
import 'package:nbq_mobile_client/src/data/data_manager.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/data/product.dart';

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

  final _wtfProducts = <Spray>[];
  final _proProducts = <Spray>[];
  final _slowProducts = <Spray>[];
  final _fastProducts = <Spray>[];
  final _capsProducts = <Cap>[];

  final _data = OrderData();

  AutovalidateMode _mode = AutovalidateMode.disabled;

  var _cans = 0;
  var _packs = 0;

  Future<void> _loadProducts() async {
    final cart = DataManager.cart as Cart;

    _slowProducts.clear();
    _fastProducts.clear();
    _wtfProducts.clear();
    _proProducts.clear();

    _cans = _packs = 0;
    for (final key in cart.slow) {
      _slowProducts.add(await DataManager.loadSpray(0, key));
    }
    for (final key in cart.fast) {
      _fastProducts.add(await DataManager.loadSpray(1, key));
    }
    for (final key in cart.wtf) {
      _wtfProducts.add(await DataManager.loadSpray(2, key));
    }
    for (final key in cart.pro) {
      _proProducts.add(await DataManager.loadSpray(3, key));
    }
    for (final key in cart.caps) {
      _capsProducts.add(await DataManager.loadSpray(4, key));
    }

    setState(() => _loading = false);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

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
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, .2),
              blurRadius: 10,
            )
          ],
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
                if (_slowProducts.isNotEmpty ||
                    _fastProducts.isNotEmpty ||
                    _wtfProducts.isNotEmpty ||
                    _proProducts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            DataManager.clearAllSelection(0);
                            DataManager.clearAllSelection(1);
                            DataManager.clearAllSelection(2);
                            DataManager.clearAllSelection(3);
                            DataManager.clearAllSelection(4);

                            setState(() {
                              _slowProducts
                                ..forEach((element) {
                                  element.singleQty = 0;
                                  element.boxQty = 0;
                                  element.save();
                                })
                                ..clear();
                              _slowProducts
                                ..forEach((element) {
                                  element.singleQty = 0;
                                  element.boxQty = 0;
                                  element.save();
                                })
                                ..clear();
                              _fastProducts
                                ..forEach((element) {
                                  element.singleQty = 0;
                                  element.boxQty = 0;
                                  element.save();
                                })
                                ..clear();
                              _wtfProducts
                                ..forEach((element) {
                                  element.singleQty = 0;
                                  element.boxQty = 0;
                                  element.save();
                                })
                                ..clear();
                              _proProducts
                                ..forEach((element) {
                                  element.singleQty = 0;
                                  element.boxQty = 0;
                                  element.save();
                                })
                                ..clear();
                              _capsProducts
                                ..forEach((element) {
                                  element.singleQty = 0;
                                  element.boxQty = 0;
                                  element.save();
                                })
                                ..clear();
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
                if (_capsProducts.isNotEmpty) ...[
                  SliverToBoxAdapter(child: _buildHeader('CAPS')),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: ColorTile(_capsProducts[index]),
                      ),
                      childCount: _capsProducts.length,
                    ),
                  ),
                ],
                if (_slowProducts.isNotEmpty ||
                    _fastProducts.isNotEmpty ||
                    _wtfProducts.isNotEmpty ||
                    _proProducts.isNotEmpty) ...[
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
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(100),
                        child: Text(
                          lang.noProducts,
                          style: TextStyle(fontSize: 20, fontFamily: 'Futura'),
                        ),
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
        _totalCans += element.singleQty ?? 0;
        _totalPacks += element.boxQty ?? 0;
      });
      _slowProducts.sort((first, second) {
        return (double.tryParse(first.sku) ?? 0).toInt() -
            (double.tryParse(second.sku) ?? 0).toInt();
      });
    }
    if (_fastProducts.isNotEmpty) {
      _fastProducts.forEach((element) {
        _totalCans += element.singleQty ?? 0;
        _totalPacks += element.boxQty ?? 0;
      });
      _fastProducts.sort((first, second) {
        return (double.tryParse(first.sku) ?? 0).toInt() -
            (double.tryParse(second.sku) ?? 0).toInt();
      });
    }
    if (_wtfProducts.isNotEmpty) {
      _wtfProducts.forEach((element) {
        _totalCans += element.singleQty ?? 0;
        _totalPacks += element.boxQty ?? 0;
      });
      _wtfProducts.sort((first, second) {
        return (double.tryParse(first.ref.substring(1)) ?? 0).toInt() -
            (double.tryParse(second.ref.substring(1)) ?? 0).toInt();
      });
    }
    if (_proProducts.isNotEmpty) {
      _proProducts.forEach((element) {
        _totalCans += element.singleQty ?? 0;
        _totalPacks += element.boxQty ?? 0;
      });
      _proProducts.sort((first, second) {
        return (double.tryParse(first.sku) ?? 0).toInt() -
            (double.tryParse(second.sku) ?? 0).toInt();
      });
    }
    if (_capsProducts.isNotEmpty) {
      _capsProducts.forEach((element) {
        _totalCans += element.singleQty ?? 0;
        _totalPacks += element.boxQty ?? 0;
      });
    }

    var products = [
      if (_slowProducts.isNotEmpty) ...['SLOW', ..._slowProducts],
      if (_fastProducts.isNotEmpty) ...['FAST', ..._fastProducts],
      if (_wtfProducts.isNotEmpty) ...['WTF', ..._wtfProducts],
      if (_proProducts.isNotEmpty) ...['PRO', ..._proProducts],
      if (_capsProducts.isNotEmpty) ...['CAPS', ..._capsProducts]
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
              e is Cap ? 'Image' : 'Color',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            if (e is Spray)
              pw.Text(
                ' Ref',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            if (e is Spray)
              pw.Text(
                ' Sku',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            pw.Text(
              ' Name',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              (e is Spray) ? ' Cans' : ' Single',
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
            columnWidths: e is Spray
                ? {
                    0: pw.FixedColumnWidth(40),
                    1: pw.FlexColumnWidth(1),
                    2: pw.FlexColumnWidth(1),
                    3: pw.FlexColumnWidth(3),
                    4: pw.FixedColumnWidth(60),
                    5: pw.FixedColumnWidth(60),
                  }
                : {
                    0: pw.FixedColumnWidth(40),
                    1: pw.FlexColumnWidth(3),
                    2: pw.FixedColumnWidth(60),
                    3: pw.FixedColumnWidth(60),
                  },
          ));
        }

        rows.add(pw.TableRow(
          children: [
            if (e is Cap) ...[
              pw.Image(pw.MemoryImage(
                  (await rootBundle.load(e.image)).buffer.asUint8List())),
              // pw.Text(''),
              // pw.Text(''),
            ] else ...[
              pw.Container(
                height: 14,
                color: PdfColor.fromInt(e?.color?.value ?? 0),
              ),
              pw.Text(' ' + e.ref),
              pw.Text(
                ' ' +
                    (e.sku == null
                        ? ''
                        : (double.tryParse(e.sku) ?? 0).toInt().toString()),
              ),
            ],
            pw.Text(' ' + e.name),
            pw.Text(' ' + (e.singleQty ?? 0).toString()),
            pw.Text(' ' + (e.boxQty ?? 0).toString())
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
              child: Center(child: Text('Lata')),
            ),
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
  final Purchasable product;

  ColorTile(this.product);

  @override
  Widget build(BuildContext context) {
    print(product?.name);
    return Row(children: [
      Expanded(
        child: Row(children: [
          if (product is Cap)
            Container(
              width: 60,
              height: 50,
              child: Image.asset(
                (product as Cap).image,
                width: 150,
                fit: BoxFit.fill,
              ),
            ),
          if (product is Spray)
            Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: (product as Spray).color,
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                  )
                ],
              ),
            ),
          SizedBox(width: 8),
          // if (product is Cap) ...[
          //   SizedBox(
          //     width: 35,
          //     child: Text(
          //       product.ref,
          //       style: TextStyle(
          //         fontFamily: 'Futura',
          //         fontWeight: FontWeight.bold,
          //         fontSize: 12,
          //       ),
          //     ),
          //   ),
          //   SizedBox(width: 8),
          // ],
          Text(product.name, style: TextStyle(fontSize: 15)),
        ]),
      ),
      ShadowedBox(
        width: 50,
        height: 20,
        borderRadius: 6,
        child: Center(
          child: Text((product.singleQty ?? 0).toString(),
              style: TextStyle(fontSize: 12)),
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
              (product.boxQty ?? 0).toString(),
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ),
    ]);
  }
}
