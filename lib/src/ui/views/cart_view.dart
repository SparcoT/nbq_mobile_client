import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:nbq_mobile_client/src/data/cart.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/ui/pages/product_detail_page.dart';
import 'package:nbq_mobile_client/src/ui/widgets/shadowed_box.dart';
import 'package:share/share.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  var isHeaderBuilt = false;

  final _slowProducts = <CartProduct>[];
  final _fastProducts = <CartProduct>[];
  final _wtfProducts = <CartProduct>[];
  final _proProducts = <CartProduct>[];

  @override
  void initState() {
    super.initState();

    _slowProducts.addAll(Cart()
        .products
        .where((e) => e.product.category == ProductCategory.slow));

    _fastProducts.addAll(Cart()
        .products
        .where((e) => e.product.category == ProductCategory.fast));

    _wtfProducts.addAll(Cart()
        .products
        .where((e) => e.product.category == ProductCategory.wtf));

    _proProducts.addAll(Cart()
        .products
        .where((e) => e.product.category == ProductCategory.pro));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
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
      if (Cart().products.isNotEmpty) ...[
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
          sliver: SliverToBoxAdapter(
            child: ElevatedButton(
              onPressed: () async {
                await _generatePdf();

                // setState(() {
                //   _slowProducts.clear();
                //   _fastProducts.clear();
                //   _wtfProducts.clear();
                //   _proProducts.clear();
                //
                //   Cart().clear();
                // });
              },
              child: Text('ENVIAR/Compartir'),
              style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: Colors.black,
                onPrimary: AppTheme.primaryColor,
                minimumSize: Size.fromHeight(40),
              ),
            ),
          ),
        ),
      ]
    ]);
  }

  pw.Table _generateTable(List<CartProduct> products) {
    return pw.Table(
      children: <pw.TableRow>[
        pw.TableRow(children: [
          pw.Text(' Color'),
          pw.Text(' Ref'),
          pw.Text(' Name'),
          pw.Text(' Cans'),
          pw.Text(' Packs')
        ]),
        ..._slowProducts.map(
          (e) => pw.TableRow(
            children: [
              pw.Container(
                color: PdfColor.fromInt(e.product.color.value),
                width: 30,
                height: 14,
              ),
              pw.Text(' ' + e.product.ref),
              pw.Text(' ' + e.product.name),
              pw.Text(' ' + e.cans.toString()),
              pw.Text(' ' + e.packs.toString())
            ],
          ),
        ),
      ],
      border: pw.TableBorder.all(color: PdfColors.black),
      columnWidths: {0: pw.FixedColumnWidth(15)},
    );
  }

  _generatePdf() async {
    final document = pw.Document();
    document.addPage(pw.Page(build: (pw.Context context) {
      return pw.Column(children: [
        pw.Column(children: [
          pw.RichText(
            text: pw.TextSpan(
                text: 'Name: ',
                children: [pw.TextSpan(text: 'Name of Person')]),
          ),
          pw.RichText(
            text: pw.TextSpan(
                text: 'Email: ',
                children: [pw.TextSpan(text: 'Email of Person')]),
          ),
          pw.RichText(
            text: pw.TextSpan(
                text: 'Phone: ',
                children: [pw.TextSpan(text: 'Telephone of Person')]),
          )
        ], crossAxisAlignment: pw.CrossAxisAlignment.start),

        pw.Divider(),

        if (_slowProducts.isNotEmpty) ...[
          pw.Text('SLOW'),
          _generateTable(_slowProducts),
        ],

        if (_fastProducts.isNotEmpty) ...[
          pw.Text('FAST'),
          _generateTable(_fastProducts),
        ],

        if (_wtfProducts.isNotEmpty) ...[
          pw.Text('WTF'),
          _generateTable(_wtfProducts),
        ],

        if (_proProducts.isNotEmpty) ...[
          pw.Text('PRO'),
          _generateTable(_proProducts),
        ],
      ], crossAxisAlignment: pw.CrossAxisAlignment.start);
    }));

    final path = Directory.systemTemp.path + '/order${DateTime.now()}.pdf';
    final file = File(path);
    file.writeAsBytes(await document.save());

    Share.shareFiles([path]);
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
