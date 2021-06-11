import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:pdf/pdf.dart';

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

  Purchasable({this.id, this.name, this.boxQty, this.singleQty, this.ref});
}

@HiveType(typeId: 1)
class Spray extends Purchasable {
  @HiveField(5)
  String ml;
  @HiveField(6)
  String sku;
  @HiveField(7)
  Color color;

  Spray({
    this.ml,
    this.sku,
    this.color,
    String ref,
    String name,
  }) : super(name: name, ref: ref);
}

@HiveType(typeId: 2)
class Cap extends Purchasable {
  @HiveField(5)
  String image;

  Cap({String name, String ref, this.image}) : super(name: name, ref: ref);
}
