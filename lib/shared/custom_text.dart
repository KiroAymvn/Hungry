import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  CustomText({
    required this.text,
    this.color = Colors.white,
    this.textAlign,
    this.fontSize = 20,
    this.fontWeight,
    this.maxLine=1,
    super.key,
  });

  final String text;
  final Color color;
  TextAlign? textAlign;
  final double fontSize;
  FontWeight? fontWeight;
  int ?maxLine;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      textScaler: TextScaler.linear(1.0),
      softWrap: true,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }
}
