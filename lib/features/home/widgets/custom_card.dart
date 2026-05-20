import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';

import '../../../shared/custom_text.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rate,
    this.onTapFav,
    required this.productId,
    required this.favListId,
    this.isFavorite = false,
    this.isButtonLoading = false,
  });

  final String image, title, price, rate;
  final int productId;
  final List<int> favListId;
  final void Function()? onTapFav;
  final bool isFavorite;
  final bool isButtonLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered Image
            Expanded(
              child: image.isEmpty
                  ? const Center(
                      child: Icon(Icons.fastfood_rounded, size: 50, color: Colors.grey),
                    )
                  : Center(
                      child: Image.network(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.fastfood_rounded, size: 50, color: Colors.grey),
                      ),
                    ),
            ),
            const Gap(12),
            // Title
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: title,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                maxLine: 2,
                fontSize: 16,
              ),
            ),
            const Gap(8),
            // Rating, Price, and Favorite Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                        const Gap(4),
                        CustomText(
                          text: rate,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ],
                    ),
                    const Gap(4),
                    CustomText(
                      text: "$price LE",
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ],
                ),
                // Favorite Button
                IconButton(
                  onPressed: onTapFav,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: isButtonLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.red,
                          ),
                        )
                      : Icon(
                          isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                          color: isFavorite ? Colors.red : Colors.grey.shade400,
                          size: 26,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
