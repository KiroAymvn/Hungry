import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CustomFoodCategories extends StatefulWidget {
  CustomFoodCategories({super.key, required this.categories, required this.selectedCategory});

  final List categories;
  final int selectedCategory;

  @override
  State<CustomFoodCategories> createState() => _CustomFoodCategoriesState();
}

class _CustomFoodCategoriesState extends State<CustomFoodCategories> {
  late int selectedCategory;

  @override
  void initState() {
    selectedCategory = widget.selectedCategory;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.categories.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child:  GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = index;
                });
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),

                  color: selectedCategory == index ? AppColors.secondary : AppColors.darkCoffee.withOpacity(0.2),
                ),
                padding:const EdgeInsets.symmetric(horizontal: 25, ),
                child: Center(
                  child: CustomText(
                    text: widget.categories[index],
                    fontSize: 20,
                    color: selectedCategory == index ? AppColors.basic : AppColors.darkCoffee,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
