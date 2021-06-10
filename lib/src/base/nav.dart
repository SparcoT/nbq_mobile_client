part of '../app.dart';

class _AppPage {
  final String name;

  const _AppPage(this.name);
}

class AppPages {
  static const home = _AppPage('/');
  static const signIn = _AppPage('/sign-in');
  static const products = _AppPage('/products');
  static const adminHome = _AppPage('/admin-home');
}

class AppNavigation {
  static final key = GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(BuildContext context, Widget destination) =>
      key.currentState.push(
        MaterialPageRoute(builder: (context) => destination),
      );

  static Future<dynamic> navigateToPage(BuildContext context, _AppPage page) =>
      key.currentState.pushNamed(page.name);

  static final _routes = <String, WidgetBuilder>{
    AppPages.signIn.name: (context) => SignIn(),
    AppPages.home.name: (context) => HomePage(),
    AppPages.adminHome.name: (context) => AdminHome(),
    // AppPages.products.name: (context) => ProductDetailPage()
  };
}
