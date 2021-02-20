import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductQtyCounter extends StatefulWidget {
  final int quantity;

  ProductQtyCounter([this.quantity = 0]);

  @override
  _ProductQtyCounterState createState() => _ProductQtyCounterState();
}

class _ProductQtyCounterState extends State<ProductQtyCounter> {
  int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.quantity;
  }

  void _increment() => ++_qty;
  void _decrement() => --_qty;
  void _incrementAction() => setState(_increment);
  void _decrementAction() {
    if (_qty > 0) setState(_decrement);
  }

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      primary: Colors.black,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
    );

    return Center(
      child: Container(
        width: 120,
        height: 30,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 1),
          ],
        ),
        child: Row(children: [
          SizedBox(
            width: 35,
            child: TextButton(
              style: style,
              onPressed: _decrementAction,
              child: Icon(FontAwesomeIcons.minus, size: 12),
            ),
          ),
          VerticalDivider(indent: 5, endIndent: 5, thickness: 1.5, width: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              width: 40,
              child: Text(
                _qty.toString(),
                style: GoogleFonts.bebasNeue(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          VerticalDivider(indent: 5, endIndent: 5, thickness: 1.5, width: 0),
          SizedBox(
            width: 35,
            child: TextButton(
              style: style,
              onPressed: _incrementAction,
              child: Icon(FontAwesomeIcons.plus, size: 12),
            ),
          ),
        ]),
      ),
    );
  }
}
