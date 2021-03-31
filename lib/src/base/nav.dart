part of '../app.dart';

class _AppPage {
  final String name;

  const _AppPage(this.name);
}

class AppPages {
  static const home = _AppPage('/');
}

class AppNavigation {
  static Future<dynamic> navigateTo(BuildContext context, Widget destination) =>
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => destination),
      );

  static Future<dynamic> navigateToPage(BuildContext context, _AppPage page) =>
      Navigator.of(context).pushNamed(page.name);

  static final _routes = <String, WidgetBuilder>{
    /// TODO: Change This
    AppPages.home.name: (context) => HomePage()
  };
}
