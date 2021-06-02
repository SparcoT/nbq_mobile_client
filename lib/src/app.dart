import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nbq_mobile_client/src/data/db.dart';
import 'package:nbq_mobile_client/src/data/cart.dart';
import 'package:nbq_mobile_client/src/ui/pages/signin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/src/adapters/color_adapter.dart';
import 'package:nbq_mobile_client/src/ui/pages/home_page.dart';
import 'package:nbq_mobile_client/src/ui/pages/admin/admin-home.dart';
import 'package:nbq_mobile_client/src/ui/widgets/localization_selector.dart';

part 'base/nav.dart';
part 'base/theme.dart';

class App extends StatelessWidget {
  const App();

  static Future<void> initializeAndRun() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    Hive.registerAdapter(ProductCategoryAdapter());
    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(CartProductAdapter());
    Hive.registerAdapter(ColorAdapter());

    await Hive.openLazyBox<Product>('products');
    await Hive.openLazyBox<CartProduct>('cart_products');

    return runApp(const App());
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LocalizationSelector.locale,
      builder: (BuildContext context, value, Widget child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NBQ',
          locale: value,
          theme: AppTheme._light,
          routes: AppNavigation._routes,
          navigatorKey: AppNavigation.key,
          supportedLocales: AppLocalizations.supportedLocales,
          // scaffoldMessengerKey: UIService._scaffoldMessengerKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      },
    );
  }
}
