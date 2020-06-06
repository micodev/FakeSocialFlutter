import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locator.dart';
import 'tweet_post.dart';
import 'dart:convert';

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

Future saveLatest(String name, String username, String profilePhoto) async {
  final pref = locator.get<SharedPreferences>();
  await pref.setString("name", name);
  await pref.setString("username", username);
  await pref.setString("profilePhoto", profilePhoto);
}

Future deleteLatest() async {
  final pref = locator.get<SharedPreferences>();
  await pref.clear();
}

TweetPost getProf() {
  final pref = locator.get<SharedPreferences>();
  String name = pref.getString("name");
  String username = pref.getString("username");
  String profilePhoto = pref.getString("profilePhoto");
  return TweetPost(
      name, username, profilePhoto == null ? null : base64Decode(profilePhoto));
}
