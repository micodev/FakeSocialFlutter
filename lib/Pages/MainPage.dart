import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:fake_tweet/Helper/NavigationService.dart';
import 'package:fake_tweet/Helper/RichTextView.dart';
import 'package:fake_tweet/Helper/locator.dart';
import 'package:fake_tweet/Helper/theme_config.dart';
import 'package:fake_tweet/Pages/FullscreenView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:jiffy/jiffy.dart';
//import 'package:permission_handler/permission_handler.dart';
import '../TwitterIcons.dart';

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
  TextEditingController _body =
      TextEditingController(text: "Insert body here.");
  String date = "";
  String likes = "";
  TextEditingController _likes = TextEditingController(text: "0");
  String retweet = "";
  TextEditingController _retweet = TextEditingController(text: "0");
  String reply = "";
  TextEditingController _reply = TextEditingController(text: "0");
  bool isVerfied = false;
  bool isliked = false;
  bool isarabicbody = false;
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  void initState() {
    super.initState();
    name = _name.text;
    username = _username.text;
    body = _body.text;
    likes = _likes.text;
    retweet = _retweet.text;
    reply = _reply.text;
    date = "${Random().nextInt(12)}:${Random().nextInt(59)}am - 26th Jan 1999";
  }

  bool isSaving = false;
  GlobalKey _globalKey = new GlobalKey();
  Future<Uint8List> imagebytes() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    return pngBytes;
  }

  Future _capturePng() async {
    setState(() {
      isSaving = true;
    });
    try {
      DownloadsPathProvider.downloadsDirectory.then((v) async {
        //final status = await Permission.storage.request();
        //if (status == PermissionStatus.granted) {
        final file =
            await new File("${v.path}/screen${Random().nextInt(919199)}.png")
                .writeAsBytes(await imagebytes());
        await file.create(recursive: true);
        await GallerySaver.saveImage(file.path, albumName: "Downloads");
        await file.delete();
        //}
        _scaffold.currentState.hideCurrentSnackBar();
        _scaffold.currentState.showSnackBar(SnackBar(
          content: Text("The image saved successfully."),
          duration: Duration(seconds: 3),
        ));
        setState(() {
          isSaving = false;
        });
      });
    } catch (e) {
      _scaffold.currentState.hideCurrentSnackBar();
      _scaffold.currentState.showSnackBar(SnackBar(
        content: Text("Problem with saving it."),
        duration: Duration(seconds: 3),
      ));
      setState(() {
        isSaving = false;
      });
      print(e);
    }
  }

  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
      }),
      child: ThemeSwitchingArea(
        child: Scaffold(
          key: _scaffold,
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.fullscreen),
                onPressed: () async {
                  Uint8List img = await imagebytes();
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullScreenCapture(
                            img: Image.memory(img),
                          )));
                },
              ),
              isSaving
                  ? SizedBox()
                  : IconButton(
                      icon: Icon(Icons.save),
                      onPressed: _capturePng,
                    ),
              ThemeSwitcher(
                clipper: ThemeSwitcherCircleClipper(),
                builder: (context) {
                  return IconButton(
                    icon:
                        ThemeProvider.of(context).brightness == Brightness.light
                            ? Icon(Icons.wb_incandescent)
                            : Icon(Icons.lightbulb_outline),
                    onPressed: () {
                      ThemeSwitcher.of(context).changeTheme(
                        theme: ThemeProvider.of(context).brightness ==
                                Brightness.light
                            ? darkTheme
                            : lightTheme,
                      );
                    },
                  );
                },
              ),
            ],
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
                            backgroundColor:
                                _image != null ? Colors.transparent : null,
                            backgroundImage: _image != null
                                ? Image.file(_image).image
                                : null,
                            child: _image != null ? null : Icon(Icons.person),
                            radius: 20,
                          ),
                          title: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Text(
                                  name == "" ? "name" : name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              isVerfied
                                  ? Icon(
                                      TwitterIcons.twitter_verified_badge,
                                      color: Colors.blueAccent,
                                      size: 16,
                                    )
                                  : SizedBox(),
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
                          padding: const EdgeInsets.fromLTRB(72.0, 0, 16, 0),
                          child: Column(
                            children: <Widget>[
                              Directionality(
                                textDirection: isarabicbody
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: SmartText(
                                          text: body != ""
                                              ? body
                                              : "Insert body here.",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    )
                                  ],
                                ),
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
                                        Text(intl.NumberFormat.compact()
                                            .format(double.parse(reply)))
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
                                        Text(intl.NumberFormat.compact()
                                            .format(double.parse(retweet)))
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          isliked
                                              ? TwitterIcons.heart_filled
                                              : TwitterIcons.heart_outline,
                                          size: 16,
                                          color:
                                              isliked ? Colors.red[600] : null,
                                        ),
                                        SizedBox(width: 10),
                                        Text(intl.NumberFormat.compact()
                                            .format(double.parse(likes)))
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                          SizedBox(
                            width: 10,
                          ),
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
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.person)
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                              child: TextField(
                            textDirection: isarabicbody
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            maxLength: 700,
                            minLines: 1,
                            maxLines: 30,
                            controller: _body,
                            onChanged: (v) => setState(() {
                              body = _body.text;
                            }),
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.border_color)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          CircleAvatar(
                            child: IconButton(
                                icon: Icon(Icons.date_range),
                                onPressed: _showDatePicker),
                          ),
                          CircleAvatar(
                            child: IconButton(
                                icon: Icon(TwitterIcons.comment_filled),
                                onPressed: () => numPicker(1)),
                          ),
                          CircleAvatar(
                            child: IconButton(
                                icon: Icon(TwitterIcons.retweet_filled),
                                onPressed: () => numPicker(2)),
                          ),
                          CircleAvatar(
                            child: IconButton(
                                icon: Icon(TwitterIcons.heart_filled),
                                onPressed: () => numPicker(3)),
                          ),
                          CircleAvatar(
                            child: IconButton(
                                icon: _image != null
                                    ? Icon(Icons.broken_image)
                                    : Icon(Icons.image),
                                onPressed: () {
                                  if (_image != null) {
                                    setState(() {
                                      _image = null;
                                    });
                                  } else {
                                    getImage();
                                  }
                                }),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Text("Is arabic body ?"),
                        trailing: Switch(
                          value: isarabicbody,
                          onChanged: (bool newValue) {
                            setState(() {
                              isarabicbody = newValue;
                            });
                          },
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Text("Is verfied ?"),
                        trailing: Switch(
                          value: isVerfied,
                          onChanged: (bool newValue) {
                            setState(() {
                              isVerfied = newValue;
                            });
                          },
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      ListTile(
                        leading: Text("Is liked ?"),
                        trailing: Switch(
                          value: isliked,
                          onChanged: (bool newValue) {
                            setState(() {
                              isliked = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    DateTime dt = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1999),
        lastDate: DateTime(2023));
    setState(() {
      if (dt == null) {
        date =
            "${Random().nextInt(12)}:${Random().nextInt(59)}am - 26th Jan 1999";
      } else {
        date =
            "${Random().nextInt(12)}:${Random().nextInt(59)}am - ${Jiffy(dt).format("do MMM yyyy")}";
      }
    });
  }

  numPicker(int i) async {
    TextEditingController tr;
    switch (i) {
      case 1:
        tr = _reply;
        break;
      case 2:
        tr = _retweet;
        break;
      case 3:
        tr = _likes;
        break;
    }

    final BuildContext con =
        locator<NavigationService>().navigatorKey.currentState.overlay.context;

    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
              begin: 0, end: 9999, initValue: int.parse(tr.text)),
        ]),
        hideHeader: true,
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          int val = value[0];
          tr.text = val.toString();
          switch (i) {
            case 1:
              _reply = tr;
              reply = _reply.text;
              break;
            case 2:
              _retweet = tr;
              retweet = _retweet.text;
              break;
            case 3:
              _likes = tr;
              likes = _likes.text;
              break;
          }
          setState(() {});
        }).showDialog(con);
  }
}
