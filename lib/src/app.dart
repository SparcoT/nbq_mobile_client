import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/ui/pages/home_page.dart';

part 'base/nav.dart';
part 'base/theme.dart';
part 'base/ui_service.dart';

class App extends StatelessWidget {
  const App();

  static Future<void> initializeAndRun() async {
    return runApp(const App());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NBQ',
      theme: AppTheme._light,
      routes: AppNavigation._routes,
      scaffoldMessengerKey: UIService._scaffoldMessengerKey,
    );
  }
}
