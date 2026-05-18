import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';

import '../../../shared/custom_text.dart';

class CustomCard extends StatelessWidget {
  CustomCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rate,
    this.onTapFav,
    required this.productId,
    required this.favListId,
     this.isFavorite=false
  });

  final String image, title, price, rate;
  final int productId;
  List<int> favListId;
  void Function()? onTapFav;
bool isFavorite;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Stack(
        children: [
          Gap(75),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                gradient: LinearGradient(
                  colors: [AppColors.primary, Colors.white, Colors.blueGrey],
                  tileMode: TileMode.clamp,
                  begin: AlignmentGeometry.topLeft,
                  stops: [0.001, 1.2, 0.9],
                  end: AlignmentGeometry.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(75),
                    CustomText(text: title, color: Colors.black, fontWeight: FontWeight.bold, maxLine: 5, fontSize: 18),
                    Align(
                      alignment: AlignmentGeometry.topLeft,
                      child: CustomText(text: price + " LE", color: AppColors.darkCoffee),
                    ),
                    Row(
                      children: [
                        CustomText(text: "⭐ $rate", color: Colors.black),
                        Spacer(),
                        IconButton(
                          onPressed: onTapFav,
                          icon: isFavorite
                              ? Icon(CupertinoIcons.heart_fill, color: Colors.red)
                              : Icon(CupertinoIcons.heart),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: 0,
            left: 10,
            child: Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.none,
              children: [
                Positioned(left: 0, right: 15, bottom: -10, child: Image.asset("assets/icon/shadow.png")),
                image.isEmpty
                    ? const SizedBox(height: 150)
                    : Image.network(
                        image,
                        height: 150,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(height: 150, child: Icon(Icons.image_not_supported)),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
