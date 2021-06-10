import 'package:hive/hive.dart';
import 'package:nbq_mobile_client/src/data/db.dart';

part 'cart.g.dart';

@HiveType(typeId: 5)
class CartProduct with HiveObjectMixin {
  @HiveField(0)
  int cans;
  @HiveField(1)
  int packs;
  @HiveField(3)
  Product product;

  CartProduct({this.product, this.cans = 0, this.packs = 0});
}

class Cart {
  Cart._();

  factory Cart() => _instance;

  static final _instance = Cart._();

  final _products = <CartProduct>[];

  List<CartProduct> get products => _products;

  void add(CartProduct product) {
    _products.add(product);
  }

  void addAll(Iterable<CartProduct> products) {
    _products.addAll(products);
  }


  void removeProductsOf(ProductCategory category) {
    _products.removeWhere((element) => element.product.category == category);
  }

  void clear() => _products.clear();
}
