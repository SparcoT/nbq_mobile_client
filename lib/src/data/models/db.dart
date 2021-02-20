import 'dart:ui';

part 'db.g.dart';

enum ProductCategory { slow, fast, wtf, pro }

class Product {
  final String ml;
  final String ref;
  final String name;
  final Color color;
  final ProductCategory category;

  const Product._(this.category, {this.name, this.ml, this.ref, this.color});

  static const all = _products;

}
