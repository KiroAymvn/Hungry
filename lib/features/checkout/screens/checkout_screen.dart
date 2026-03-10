import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/checkout/widgets/custom_order_details.dart';
import 'package:hungry/shared/custom_text.dart';

import '../../../shared/custom_button.dart';
import '../widgets/check_out_widget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedMethod = "cash";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: "Order Summary", color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
            CustomOrderDetails(),
            Gap(50),
            CustomText(text: "Payment Method", color: Colors.black),
            Gap(10),

            //cash
            ListTile(
              onTap: () => setState(() => selectedMethod = "cash"),

              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 8),
              tileColor: Color(0xff342929),
              leading: Image.asset("assets/icon/cash.png", width: 75),
              title: CustomText(text: "Cash on Delivery"),
              trailing: Radio<String>(
                value: "cash",
                groupValue: selectedMethod,
                onChanged: (v) {
                  setState(() {
                    selectedMethod = v!;
                  });
                },
                activeColor: Colors.white,
              ),
            ),
            Gap(10),
            //visa
            ListTile(
              onTap: () => setState(() => selectedMethod = "visa"),
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 8),
              tileColor: Color(0xff0d3e96),
              leading: Image.asset("assets/icon/visa.webp", width: 75),
              title: CustomText(text: "Debit Card"),
              trailing: Radio<String>(
                value: "visa",
                groupValue: selectedMethod,
                onChanged: (v) {
                  setState(() {
                    selectedMethod = v!;
                  });
                },
                activeColor: Colors.white,
              ),
              subtitle: CustomText(text: "**** **** **** 4529", fontSize: 15),
            ),
            Gap(20),
            Row(
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(value: true, onChanged: (v) {}, activeColor: Colors.red),
                ),
                CustomText(text: "Save card details for future payments", color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, -6), blurRadius: 20)],
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        padding: EdgeInsetsGeometry.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Total", color: Colors.black, fontSize: 22),
                CustomText(text: "\$18.79", color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
              ],
            ),
            CustomButton(
              text: "Pay now",
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(elevation: 0,

                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 220),
                        child: Container(
                          padding: EdgeInsetsGeometry.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(0, -6), blurRadius: 20)],
                            borderRadius: BorderRadiusGeometry.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary,
                                radius: 50,
                                child: Icon(Icons.check, color: Colors.white, size: 50),
                              ),
                              Gap(20),
                              CustomText(
                                text: "Success",
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                              CustomText(
                                text: "Your payment was successful \n receipt foor this purchase \n has been sent to your email",
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                              Gap(10),
                              CustomButton(text: "Close",width: 300,onTap: (){Navigator.pop(context);},)
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
