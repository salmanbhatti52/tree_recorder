import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inbetrieb/resources/appColors.dart';
import 'package:url_launcher/url_launcher.dart';

class MyText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign align;
  final FontStyle? style;
  final TextDecoration? textDecoration;
  const MyText({
    super.key,
    required this.text,
    this.textDecoration,
    this.style,
    this.color = AppColor.primaryColor,
    this.fontSize = 28,
    this.fontWeight = FontWeight.w700,
    this.align = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "SF Pro Display",
        color: color,
        fontStyle: style,
        decoration: textDecoration,
        decorationColor: Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: align,
    );
  }
}

class MyRichText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const MyRichText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];

    List<String> words = text.split(RegExp(r'(\s)'));


    for (String word in words) {
      if (_isLink(word)) {
        spans.add(
          TextSpan(
              text: "$word ",
              style: const TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri url = Uri.parse(word);
                  if (!await launchUrl(url)) {
                    throw Exception('Could not launch $url');
                  }
                },
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              color: AppColor.lightBlackColor,
            ),
          ),
        );
      }
    }

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        children: spans,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  bool _isLink(String text) {
    RegExp urlRegex = RegExp(
      r'^(http|https)://([\w.]+/?)\S*$',
      caseSensitive: false,
    );

    Iterable<Match> matches = urlRegex.allMatches(text);
    for (Match match in matches) {
      debugPrint('Matched link: ${match.group(0)}');
    }

    return urlRegex.hasMatch(text.trim());
  }
}
