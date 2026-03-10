import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CustomAuthBtn extends StatelessWidget {
  CustomAuthBtn({
    super.key,
    required this.formKey,
    required this.text,
    this.onTap,
    this.bgColor = Colors.white,
    this.borderColor,
    this.textColor = AppColors.primary,
    this.isLoading = true,
  });

  final GlobalKey<FormState> formKey;
  final String text;
  final Function()? onTap;
  Color textColor;
  Color bgColor;
  Color? borderColor;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        child: Center(
          child: CustomText(text: text, color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
