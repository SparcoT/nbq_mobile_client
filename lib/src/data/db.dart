import 'dart:ui';
import 'package:hive/hive.dart';

part 'db.g.dart';

@HiveType(typeId: 2)
enum ProductCategory {
  @HiveField(0)
  slow,
  @HiveField(1)
  fast,
  @HiveField(2)
  wtf,
  @HiveField(3)
  pro
}

@HiveType(typeId: 1)
class Product with HiveObjectMixin {
  @HiveField(0)
  final String ml;
  @HiveField(1)
  final double sku;
  @HiveField(2)
  final String ref;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final Color color;
  @HiveField(5)
  final ProductCategory category;

  Product(
    this.category, {
    this.name,
    this.ml,
    this.ref,
    this.color,
    this.sku,
  });

  // static final all = _products;
}
