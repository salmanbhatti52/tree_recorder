import 'package:flutter/material.dart';
import 'package:inbetrieb/resources/appAssets.dart';

class ImageContainer extends StatelessWidget {
  final Widget child;
  final String imagePath;
  const ImageContainer({Key? key, required this.child, this.imagePath = AppAssets.bgImage,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          alignment: Alignment.topLeft,
        ),
      ),
      child: child,
    );
  }
}
