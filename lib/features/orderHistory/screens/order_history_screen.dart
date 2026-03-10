import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';
import '../../cart/widgets/cutsom_cart_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset("assets/image 6.png", width: 120),
                                Gap(20),
                                Column(
                                  children: [
                                    CustomText(
                                      text: "Hamberger Name ",
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    CustomText(text: "Qty:X3", color: Colors.black, fontWeight: FontWeight.bold),
                                    CustomText(text: "Price : 20\$", color: Colors.black, fontWeight: FontWeight.bold),
                                  ],
                                ),
                              ],
                            ),
                            Gap(10),
                            Container(
                              width: 300,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusGeometry.circular(20),
                                color: Colors.grey,
                              ),
                              child: Center(child: CustomText(text: "Order again",)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
