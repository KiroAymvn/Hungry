import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CustomAddOrMinusButton extends StatelessWidget {
  const CustomAddOrMinusButton({
    super.key, required this.icon, required this.onTap,
  });
  final IconData icon;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
