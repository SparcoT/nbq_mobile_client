import 'package:nbq_mobile_client/src/data/db.dart';

class CartProduct {
  int _cans;
  int _packs;
  final Product product;

  CartProduct(this.product) : _cans = 0, _packs = 0;

  incrementCans() => ++_cans;
  decrementCans() {
    if (_cans > 0) --_cans;
  }

  incrementPacks() => ++_packs;
  decrementPacks() {
    if (_cans > 0) --_packs;
  }

  int get cans => _cans;
  int get packs => _packs;
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