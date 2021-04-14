part of '../app.dart';

class _AppPage {
  final String name;

  const _AppPage(this.name);
}

class AppPages {
  static const home = _AppPage('/');
  static const signIn = _AppPage('/sign-in');
}

class AppNavigation {
  static Future<dynamic> navigateTo(BuildContext context, Widget destination) =>
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => destination),
      );

  static Future<dynamic> navigateToPage(BuildContext context, _AppPage page) =>
      Navigator.of(context).pushNamed(page.name);

  static final _routes = <String, WidgetBuilder>{
    AppPages.signIn.name: (context) => SignIn(),
    AppPages.home.name: (context) => HomePage()
  };
}
