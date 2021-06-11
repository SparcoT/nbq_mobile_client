import 'dart:ui';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nbq_mobile_client/src/data/product.dart';
import 'package:hive_flutter/src/adapters/color_adapter.dart';

abstract class DataManager {
  static Box<Cart> _cartBox;
  static LazyBox<Cap> _caps;
  static LazyBox<Spray> _spraysSlow;
  static LazyBox<Spray> _spraysFast;
  static LazyBox<Spray> _spraysPro;
  static LazyBox<Spray> _spraysWtf;

  static get caps => _caps.keys;

  static get slowSprays => _spraysSlow.keys;

  static get fastSprays => _spraysFast.keys;

  static get proSprays => _spraysPro.keys;

  static get wtfSprays => _spraysWtf.keys;

  static get cart => _cartBox.values.first;

  static Future<void> initializeDB() async {
    await Hive.initFlutter();

    Hive.registerAdapter(SprayAdapter());
    Hive.registerAdapter(CapAdapter());
    Hive.registerAdapter(ColorAdapter());
    Hive.registerAdapter(CartAdapter());

    _cartBox = await Hive.openBox('cart');
    _caps = await Hive.openLazyBox<Cap>('caps');
    _spraysSlow = await Hive.openLazyBox<Spray>('sprays_slow');
    _spraysFast = await Hive.openLazyBox<Spray>('sprays_fast');
    _spraysPro = await Hive.openLazyBox<Spray>('sprays_pro');
    _spraysWtf = await Hive.openLazyBox<Spray>('sprays_wtf');

    if (_spraysFast.isEmpty) {
      _loadJsonToDB(_caps, _spraysSlow, _spraysFast, _spraysPro, _spraysWtf);
      final cart = Cart();
      await _cartBox.add(cart);
      await cart.save();
    }
  }

  static Future<Purchasable> loadSpray(int type, dynamic id) async {
    switch (type) {
      case 0:
        return _spraysSlow.get(id);
      case 1:
        return _spraysFast.get(id);
      case 2:
        return _spraysWtf.get(id);
      case 3:
        return _spraysPro.get(id);
      case 4:
        return _caps.get(id);
    }
  }

  static Future<void> clearAllSelection(int type) async {
    final cart = _cartBox.values.first;

    switch (type) {
      case 0:
        cart.slow.clear();
        break;
      case 1:
        cart.fast.clear();
        break;
      case 2:
        cart.wtf.clear();
        break;
      case 3:
        cart.pro.clear();
        break;
      case 4:
        cart.caps.clear();
        break;
    }

    return cart.save();
  }

  static Future<void> removeFromCartSelection(int type, int id) async {
    final cart = _cartBox.values.first;

    switch (type) {
      case 0:
        cart.slow.remove(id);
        break;
      case 1:
        cart.fast.remove(id);
        break;
      case 2:
        cart.wtf.remove(id);
        break;
      case 3:
        cart.pro.remove(id);
        break;
      case 4:
        cart.caps.remove(id);
        break;
    }

    return cart.save();
  }

  static void addToCart(int type, int id) {
    final cart = _cartBox.values.first;

    switch (type) {
      case 0:
        if (!cart.slow.contains(id)) cart.slow.add(id);
        break;
      case 1:
        if (!cart.fast.contains(id)) cart.fast.add(id);
        break;
      case 2:
        if (!cart.wtf.contains(id)) cart.wtf.add(id);
        break;
      case 3:
        if (!cart.pro.contains(id)) cart.pro.add(id);
        break;
      case 4:
        if (!cart.caps.contains(id)) cart.caps.add(id);
        break;
    }

    print('SLOW => ${cart.slow}');
    print('FAST => ${cart.fast}');
    print('WTF => ${cart.wtf}');
    print('PRO => ${cart.pro}');
    print('CAPS => ${cart.caps}');

    cart.save();
  }

  static int getCount(int type) {
    switch (type) {
      case 0:
        return _spraysSlow.length;
      case 1:
        return _spraysFast.length;
      case 2:
        return _spraysWtf.length;
      case 3:
        return _spraysPro.length;
      case 4:
        return _caps.length;
    }
  }
}

Future<void> _loadJsonToDB(
  LazyBox<Cap> caps,
  LazyBox<Spray> slow,
  LazyBox<Spray> fast,
  LazyBox<Spray> pro,
  LazyBox<Spray> wtf,
) async {
  int count = 0;
  final products = jsonDecode(await rootBundle.loadString('assets/db.json'));

  for (final product in products) {
    if (product['type'] == 'spray') {
      final color = product['color'];
      final spray = Spray(
        color: Color.fromRGBO(color['r'], color['g'], color['b'], color['o']),
        ml: product['ml'].toString(),
        ref: product['ref'].toString(),
        sku: product['sku'].toString(),
        name: product['name'].toString(),
      )..id = ++count;
      if (product['category'] == 'slow') {
        await slow.put(count, spray);
      } else if (product['category'] == 'fast') {
        await fast.put(count, spray);
      } else if (product['category'] == 'wtf') {
        await wtf.put(count, spray);
      } else if (product['category'] == 'pro') {
        await pro.put(count, spray);
      }

      await spray.save();
    } else {
      final cap = Cap(name: product['name'], image: product['image'])
        ..id = ++count;
      await caps.put(count, cap);
      await cap.save();
    }
  }
}