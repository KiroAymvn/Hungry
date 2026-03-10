import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hungry/features/auth/screens/profile_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CustomUserHeader extends StatelessWidget {
  const CustomUserHeader({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset("assets/logo/logo.svg", color: AppColors.primary),
            CustomText(text: "Are you hungry ?", color: Colors.grey.shade600),
          ],
        ),
        const  Spacer(),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: AssetImage("assets/test/kunckles.jpg")),
          ),
        ),
      ],
    );
  }
}
