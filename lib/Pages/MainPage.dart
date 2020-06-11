import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:fake_tweet/Helper/CustomTheme.dart';
import 'package:fake_tweet/Helper/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

//ThemeProvider.of(context) == ThemeData.light()
class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    bool islight = ThemeProvider.of(context) == ThemeData.light();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Router.insta);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.instagramSquare),
                          Text(
                            "Instagram",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Router.tweet);
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FaIcon(
                            FontAwesomeIcons.twitterSquare,
                            color: islight
                                ? CustomTheme.twitterIconLight
                                : CustomTheme.twitterIconDark,
                          ),
                          Text(
                            "Twitter",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
