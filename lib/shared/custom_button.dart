import 'package:flutter/cupertino.dart';

import '../core/constants/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    this.width=175,
    this.height=60,
    this.fontWeight=FontWeight.normal,
     this.color,
    this.textColor=CupertinoColors.white,
    this.fontSize=20,
    super.key, required this.text, this.onTap,
  });
  final String text;
  final void Function()? onTap;
  double width;
  double height;
  double?fontSize;
  FontWeight fontWeight;
  Color ?color;
  Color ?textColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: color ?? AppColors.primary, borderRadius: BorderRadiusGeometry.circular(20)),
        child: Center(
          child: CustomText(text: text, fontSize: fontSize!, fontWeight: fontWeight,color: textColor!),
        ),
      ),
    );
  }
}
