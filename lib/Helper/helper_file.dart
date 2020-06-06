import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locator.dart';
import 'tweet_post.dart';

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

Future saveLatest(String name, String username, List<int> profilePhoto) async {
  final pref = locator.get<SharedPreferences>();
  await pref.setString("name", name);
  await pref.setString("username", username);
  List<String> _profilePhoto = List<String>();
  profilePhoto?.forEach((element) => _profilePhoto.add(element.toString()));
  await pref.setStringList(
      "profilePhoto", _profilePhoto.length == 0 ? null : _profilePhoto);
}

Future deleteLatest() async {
  final pref = locator.get<SharedPreferences>();
  await pref.clear();
}

TweetPost getProf() {
  final pref = locator.get<SharedPreferences>();
  String name = pref.getString("name");
  String username = pref.getString("username");
  List<int> _profilePhoto = List<int>();
  pref
      .getStringList("profilePhoto")
      ?.forEach((element) => _profilePhoto.add(int.parse(element)));
  return TweetPost(
      name, username, _profilePhoto.length == 0 ? null : _profilePhoto);
}
