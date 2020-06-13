import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class DragItem extends StatelessWidget {
  final Size size;
  final Image img;
  DragItem({this.size, this.img}) {
    print("init class iamge");
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImage(
      width: size.width - 10,
      image: img.image,
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
