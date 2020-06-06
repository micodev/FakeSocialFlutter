import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';

Future shareImage(
    GlobalKey<ScaffoldState> _scaffold, String name, List<int> bytes) async {
  try {
    await Share.files(
        'fake screenshot',
        {
          name: bytes,
        },
        'image/png');
  } catch (e) {
    _scaffold.currentState.showSnackBar(SnackBar(
      content: Text("Error : while share the file"),
      duration: Duration(seconds: 3),
    ));
  }
}
