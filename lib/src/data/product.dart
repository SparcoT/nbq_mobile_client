import 'dart:ui';
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 5)
class Cart with HiveObjectMixin {
  @HiveField(0)
  List<dynamic> slow = [];
  @HiveField(1)
  List<dynamic> fast = [];
  @HiveField(2)
  List<dynamic> wtf = [];
  @HiveField(3)
  List<dynamic> pro = [];
  @HiveField(4)
  List<dynamic> caps = [];
  @HiveField(5)
  List<dynamic> displays = [];
}

class Purchasable with HiveObjectMixin {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int boxQty = 0;
  @HiveField(3)
  int singleQty = 0;
  @HiveField(4)
  String ref;
  @HiveField(5)
  String sku;

  Purchasable({
    this.id,
    this.name,
    this.boxQty,
    this.singleQty,
    this.ref,
    this.sku,
  });
}

@HiveType(typeId: 1)
class Spray extends Purchasable {
  @HiveField(6)
  String ml;

  // @HiveField(6)
  // String sku;
  @HiveField(7)
  Color color;
  @HiveField(8)
  int ral;
  @HiveField(9)
  int pantone;

  Spray({
    this.ml,
    this.color,
    String ref,
    String name,
    String sku,
    this.pantone,
    this.ral,
  }) : super(name: name, ref: ref, sku: sku);
}

@HiveType(typeId: 2)
class Cap extends Purchasable {
  @HiveField(6)
  String image;

  Cap({String name, String ref, this.image, String sku})
      : super(name: name, ref: ref, sku: sku);
}

@HiveType(typeId: 3)
class Displays extends Purchasable {
  Displays({String sku, String name, String ref})
      : super(name: name, ref: ref, sku: sku);
}
