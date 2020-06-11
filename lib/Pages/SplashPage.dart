import 'package:flutter/material.dart';
import '../Helper/locator.dart';
import '../Helper/router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder(
        future: locator.allReady(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              Future.delayed(Duration(seconds: 1), () {
                if (Navigator.canPop(context))
                  Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacementNamed(context, Router.main);
              });
            });
          }
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                      width: size.width / 3,
                      child: Image.asset("assets/images/Icon.png")),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
