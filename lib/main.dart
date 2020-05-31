import 'package:fake_tweet/Helper/locator.dart';
import 'package:flutter/material.dart';
import 'Helper/NavigationService.dart';
import 'Pages/MainPage.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator.get<NavigationService>().navigatorKey,
      title: 'FakeTwitter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Fake Twitter'),
    );
  }
}
