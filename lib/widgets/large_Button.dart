import 'package:flutter/material.dart';
import 'package:inbetrieb/resources/appColors.dart';

class LargeButton extends StatelessWidget {
  final double width;
  final double height;
  final Color containerColor;
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign align;
  final Function onTap;
  const LargeButton({
    Key? key,
    this.width = 340,
    this.height = 54,
    this.containerColor = AppColor.primaryColor,
    required this.text,
    this.textColor = Colors.white,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w700,
    this.align = TextAlign.center,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: containerColor,
        ),
        child: Center(
          child: Text(
            text,
            textAlign: align,
            style: TextStyle(
              fontFamily: "SF Pro Display",
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
