import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/features/home/data/model/product_model.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CustomSpicySlider extends StatelessWidget {
  const CustomSpicySlider({super.key, required this.value, required this.onChanged, required this.productModel});

  final double value;
  final void Function(double) onChanged;
  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(productModel.image, height: 150, width: 200),
            CustomText(text: "${productModel.price} LE", color: AppColors.primary, fontSize: 30),
          ],
        ),
        Align(
          alignment: AlignmentGeometry.topLeft,
          child: CustomText(
            text: productModel.name,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
            fontSize: 25,
            maxLine: 3,
          ),
        ),
        CustomText(text: productModel.description, color: Colors.grey, maxLine: 10,),
        Gap(10),
        CustomText(text: "Customize your burger", color: Colors.black, maxLine: 10,),

        Slider(
          value: value,
          onChangeEnd: (value){
            print(value);
          },
          min: 0,
          divisions: 10,
          max: 1,
          label: "Spicy",
          allowedInteraction: SliderInteraction.tapAndSlide,
          activeColor: AppColors.primary,
          inactiveColor: Colors.grey,
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "🥶", color: Colors.black),
              CustomText(text: "🌶️", color: Colors.black),
            ],
          ),
        ),
      ],
    );
  }
}
