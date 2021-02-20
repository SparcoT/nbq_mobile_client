import 'package:nbq_mobile_client/src/data/db.dart';

class CartProduct {
  int cans;
  int packs;
  final Product product;

  CartProduct(this.product) : cans = 0, packs = 0;
}

class Cart {
  Cart._();
  factory Cart() => _instance;

  static final _instance = Cart._();

  final _products = <CartProduct>[];

  void add(CartProduct product) {
    _products.add(product);
  }

  void addAll(Iterable<CartProduct> products) {
    _products.addAll(products);
  }
}