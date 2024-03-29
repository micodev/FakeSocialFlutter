import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:fake_tweet/Helper/locator.dart';
import 'package:flutter/material.dart';
import 'Helper/NavigationService.dart';
import 'Helper/theme_config.dart';
import 'Helper/router.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? darkTheme : lightTheme;
    return ThemeProvider(
        initTheme: initTheme,
        child: Builder(builder: (context) {
          return MaterialApp(
            onGenerateRoute: Router.generateRoute,
            initialRoute: Router.splash,
            debugShowCheckedModeBanner: false,
            navigatorKey: locator.get<NavigationService>().navigatorKey,
            title: 'FakeTwitter',
            theme: ThemeProvider.of(context),
            builder: (context, child) {
              return child;
            },
          );
        }));
  }
}
