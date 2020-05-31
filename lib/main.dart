import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:fake_tweet/TwitterIcons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FakeTwitter',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = "";
  TextEditingController _name = TextEditingController(text: "name");
  String username = "";
  TextEditingController _username = TextEditingController(text: "username");
  String body = "";
  TextEditingController _body = TextEditingController(text: "");
  String date = "";
  @override
  void initState() {
    super.initState();
    name = _name.text;
    username = _username.text;
    body = _body.text;
    date = "${Random().nextInt(12)}:${Random().nextInt(59)}am - 26th Jan 1999";
  }

  GlobalKey _globalKey = new GlobalKey();
  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      DownloadsPathProvider.downloadsDirectory.then((v) async {
        final status = await Permission.storage.request();
        if (status.isGranted) {
          await new File("${v.path}/screen.png").writeAsBytes(pngBytes);
          setState(() {});
        }
      });
      return pngBytes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _capturePng,
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RepaintBoundary(
              key: _globalKey,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                        radius: 20,
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(
                            name == "" ? "name" : name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            TwitterIcons.twitter_verified_badge,
                            color: Colors.blueAccent,
                            size: 16,
                          ),
                        ],
                      ),
                      subtitle:
                          Text(username == "" ? "@username" : "@$username"),
                      trailing: Icon(
                        TwitterIcons.arrow_down_outline,
                        size: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(72.0, 0, 0, 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                body != "" ? body : "Insert body here.",
                                softWrap: true,
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Text(
                                date,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                                softWrap: true,
                              )
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      TwitterIcons.comment_outline,
                                      size: 16,
                                    ),
                                    SizedBox(width: 10),
                                    Text("203")
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      TwitterIcons.retweet_outline,
                                      size: 16,
                                    ),
                                    SizedBox(width: 10),
                                    Text("203")
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      TwitterIcons.heart_outline,
                                      size: 16,
                                    ),
                                    SizedBox(width: 10),
                                    Text("203")
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      TwitterIcons.iconfinder_share_227561,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                        controller: _name,
                        onChanged: (v) => setState(() {
                          name = _name.text;
                        }),
                      )),
                      Icon(Icons.title)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                        controller: _username,
                        onChanged: (v) => setState(() {
                          username = _username.text;
                        }),
                      )),
                      Icon(Icons.person)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                        minLines: 1,
                        maxLines: 30,
                        controller: _body,
                        onChanged: (v) => setState(() {
                          body = _body.text;
                        }),
                      )),
                      Icon(Icons.border_color)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
