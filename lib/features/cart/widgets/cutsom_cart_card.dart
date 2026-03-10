import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/shared/custom_button.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import 'custom_add_or_minus_button.dart';

class CustomCartCard extends StatelessWidget {
  const CustomCartCard({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
     this.onAdd,
     this.onRemove,
     this.onMinus, required this.number,
  });

  final String image;
  final String title;
  final String desc;
  final Function() ?onAdd;
  final Function() ?onRemove;
  final Function() ?onMinus;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Row(
          children: [
            Gap(20),
            //image + text1 + text2
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(image, width: 100),
                  CustomText(text: title, color: Colors.black,maxLine: 2,),
                  CustomText(text: desc, color: Colors.black),
                ],
              ),
            ),
            // Minus , counter , add , remove
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomAddOrMinusButton(icon: CupertinoIcons.minus, onTap: ()=>onMinus),
                      CustomText(
                        text: number.toString(),
                        color: AppColors.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomAddOrMinusButton(icon: CupertinoIcons.add, onTap:()=> onAdd),
                    ],
                  ),
                  Gap(25),
                  CustomButton(text: "Remove",height: 50,onTap: onRemove,)                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
