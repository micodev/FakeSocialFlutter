import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fake_tweet/Helper/helper_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';

class FullScreenCapture extends StatefulWidget {
  final Image img;
  FullScreenCapture({Key key, this.img}) : super(key: key);

  @override
  _FullScreenCaptureState createState() => _FullScreenCaptureState();
}

class _FullScreenCaptureState extends State<FullScreenCapture> {
  Offset offset = Offset.zero;
  bool isDrag = false;
  bool isEdit = false;
  DragItem _dragItem;
  bool isSaving = false;
  GlobalKey _globalKey = new GlobalKey();
  GlobalKey<ScaffoldState> _scaffold = new GlobalKey();
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final img = widget.img;
    final size = MediaQuery.of(context).size;
    _dragItem = new DragItem(size: size, img: img);
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffold,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                await shareImage(_scaffold, "img.png", await imagebytes());
              },
            ),
            isSaving
                ? SizedBox()
                : IconButton(
                    icon: Icon(Icons.save),
                    onPressed: _capturePng,
                  ),
          ],
        ),
        floatingActionButton: isSaving
            ? null
            : FloatingActionButton(
                child: isEdit ? Icon(Icons.close) : Icon(Icons.zoom_out_map),
                onPressed: () {
                  if (mounted)
                    setState(() {
                      isEdit = !isEdit;
                    });
                }),
        body: RepaintBoundary(
          key: _globalKey,
          child: SafeArea(
            child: Container(
              color: Colors.grey[900],
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: offset.dx,
                    top: offset.dy,
                    child: isEdit
                        ? Draggable(
                            onDragStarted: () {
                              setState(() {
                                isDrag = true;
                              });
                            },
                            child: isDrag ? SizedBox() : _dragItem,
                            feedback: Container(child: _dragItem),
                            onDraggableCanceled:
                                (Velocity velocity, Offset offs) {
                              setState(() {
                                offset = Offset(offs.dx, offs.dy - 90);
                                isDrag = false;
                              });
                            },
                          )
                        : isDrag ? SizedBox() : _dragItem,
                    // child: GestureDetector(
                    //   onPanUpdate: isEdit
                    //       ? (details) {
                    //           setState(() {
                    //             offset = Offset(offset.dx + details.delta.dx,
                    //                 offset.dy + details.delta.dy);
                    //           });
                    //         }
                    //       : null,
                    //   child: _dragItem,
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void downloadFile(img) {}
}

class DragItem extends StatefulWidget {
  final Size size;
  final Image img;
  DragItem({this.size, this.img});

  @override
  _DragItemState createState() => _DragItemState();
}

class _DragItemState extends State<DragItem> {
  @override
  Widget build(BuildContext context) {
    return ExtendedImage(
      width: widget.size.width - 10,
      image: widget.img.image,
      fit: BoxFit.contain,
      enableLoadState: false,
      mode: ExtendedImageMode.gesture,
      initGestureConfigHandler: (state) {
        return GestureConfig(
          minScale: 0.9,
          animationMinScale: 0.7,
          maxScale: 3.0,
          animationMaxScale: 3.5,
          speed: 1.0,
          inertialSpeed: 100.0,
          initialScale: 1.0,
          inPageView: false,
          initialAlignment: InitialAlignment.center,
        );
      },
    );
  }
}
