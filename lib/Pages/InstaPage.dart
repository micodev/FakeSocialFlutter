import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:fake_tweet/Helper/InstagramIcons.dart';
import 'package:fake_tweet/Helper/NavigationService.dart';
import 'package:fake_tweet/Helper/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

import 'package:permission_handler/permission_handler.dart';

class InstaPostPage extends StatefulWidget {
  InstaPostPage({Key key}) : super(key: key);

  @override
  _InstaPostPageState createState() => _InstaPostPageState();
}

class _InstaPostPageState extends State<InstaPostPage> {
  String likes = "0";
  TextEditingController _likes = TextEditingController(text: "0");
  bool isLiked = false;
  Image _image;
  String username = "username";
  TextEditingController _username = TextEditingController(text: "username");
  String body = "body";
  TextEditingController _body = TextEditingController(text: "body");
  Image _postImage;
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

  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();

  //number
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  final picker = ImagePicker();
  Future getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile == null) return;

      _postImage = Image.file(File(pickedFile.path));
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile == null) {
        _image = null;
        return;
      }

      // photoProfile = File(pickedFile.path);
      _image = Image.file(File(pickedFile.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    bool islight = ThemeProvider.of(context) == ThemeData.light();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffold,
      body: SafeArea(
        child: RepaintBoundary(
          key: _globalKey,
          child: Container(
            color: islight ? Colors.white : null,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                    _image != null ? Colors.transparent : null,
                                backgroundImage:
                                    _image != null ? _image.image : null,
                                child:
                                    _image != null ? null : Icon(Icons.person),
                                radius: 20,
                              ),
                            ),
                            title: GestureDetector(
                              onTap: () {
                                showInputUsername();
                              },
                              child: Text(
                                username,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            trailing: _threeItemPopup()),
                        GestureDetector(
                          onTap: getPostImage,
                          child: Container(
                              height: size.width,
                              width: size.width,
                              child: _postImage != null
                                  ? null
                                  : Icon(Icons.add_a_photo),
                              decoration: _postImage != null
                                  ? new BoxDecoration(
                                      image: new DecorationImage(
                                      image: _postImage.image,
                                      fit: BoxFit.fill,
                                    ))
                                  : null),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isLiked = !isLiked;
                                          });
                                        },
                                        child: Icon(
                                          isLiked
                                              ? InstagramIcons.heart_fill
                                              : InstagramIcons.heart_outline,
                                          size: 25,
                                          color: isLiked ? Colors.red : null,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        InstagramIcons.comment,
                                        size: 25,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        InstagramIcons.direct,
                                        size: 25,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        InstagramIcons.bookmark,
                                        size: 25,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: numPicker,
                                    child: Text(
                                      "${likes.replaceAllMapped(reg, mathFunc)} likes",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: RichText(
                                      text: TextSpan(
                                          text: username,
                                          style: TextStyle(
                                              color:
                                                  islight ? Colors.black : null,
                                              fontWeight: FontWeight.w600),
                                          children: [
                                            WidgetSpan(
                                                child: SizedBox(
                                              width: 5,
                                            )),
                                            TextSpan(
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                                text: body)
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider()
                            ],
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
      ),
      floatingActionButton: isSaving
          ? null
          : FloatingActionButton(
              onPressed: _capturePng,
              child: Icon(Icons.save),
            ),
    );
  }

  Future _capturePng() async {
    setState(() {
      isSaving = true;
    });
    try {
      DownloadsPathProvider.downloadsDirectory.then((v) async {
        final status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          final file =
              await new File("${v.path}/screen${Random().nextInt(919199)}.png")
                  .writeAsBytes(await imagebytes());
          await file.create(recursive: true);
          await GallerySaver.saveImage(file.path, albumName: "Downloads");
        }
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

  showInputUsername() {
    showDialog(
        child: new Dialog(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(hintText: "Update Name"),
                controller: _username,
              ),
              new FlatButton(
                child: new Text("Save"),
                onPressed: () {
                  setState(() {
                    this.username = _username.text;
                  });
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        context: context);
  }

  showInputBody() {
    showDialog(
        child: new Dialog(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(hintText: "Update Body"),
                controller: _body,
              ),
              new FlatButton(
                child: new Text("Save"),
                onPressed: () {
                  setState(() {
                    this.body = _body.text;
                  });
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        context: context);
  }

  Widget _threeItemPopup() {
    bool islight = ThemeProvider.of(context) == ThemeData.light();
    return PopupMenuButton(
      onSelected: (value) {
        print(value);
        switch (value) {
          case 1:
            setState(() {
              _image = null;
            });
            break;
          case 2:
            showInputBody();
            break;
          case 3:
            setState(() {
              _postImage = null;
            });
            break;
        }
      },
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        if (_image != null)
          list.add(
            PopupMenuItem(
              child: Text(
                "Remove Profile photo",
                style: TextStyle(),
              ),
              value: 1,
            ),
          );
        if (_postImage != null)
          list.add(
            PopupMenuItem(
              child: Text(
                "Remove Body photo",
                style: TextStyle(),
              ),
              value: 3,
            ),
          );
        list.add(
          PopupMenuItem(
            child: Text(
              "Edit body",
              style: TextStyle(),
            ),
            value: 2,
          ),
        );
        return list;
      },
      icon: Icon(
        Icons.more_vert,
        color: islight ? Colors.black : null,
      ),
    );
  }

  numPicker() {
    final BuildContext con =
        locator<NavigationService>().navigatorKey.currentState.overlay.context;
    new Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(
              begin: 0, end: 10000, initValue: int.parse(_likes.text)),
        ]),
        hideHeader: true,
        title: new Text("Please Select"),
        onConfirm: (Picker picker, List value) {
          int val = value[0];
          _likes.text = val.toString();
          likes = _likes.text;
          setState(() {});
        }).showDialog(con);
  }
}
