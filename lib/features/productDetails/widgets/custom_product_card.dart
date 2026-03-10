import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/features/home/data/model/topping_model.dart';
import 'package:hungry/features/productDetails/screens/product_details_screen.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
    super.key,
    required this.topping,
    required this.id,
    required this.selectedItem,
  });

  final ToppingModel topping;
  final int id;
  final List<int> selectedItem;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedItem.contains(id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 120,
          height: 140,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.7,
                child: Image.network(
                  topping.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              const Gap(8),
              CustomText(
                text: topping.name,
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
