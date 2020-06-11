import 'package:flutter/material.dart';
import '../Pages/pages.dart';

class Router {
  static const String splash = "/splash";
  static const String main = "/main";
  static const String insta = "/insta";
  static const String tweet = "/tweet";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case main:
        return MaterialPageRoute(builder: (_) => MainPage());
      case tweet:
        return MaterialPageRoute(builder: (_) => TweetPage());
      case insta:
        return MaterialPageRoute(builder: (_) => InstaPostPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
