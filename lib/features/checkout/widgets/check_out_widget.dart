
import 'package:flutter/material.dart';

import '../../../shared/custom_text.dart';

Widget checkOutWidget(String title, double price, bool isBold) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        text: title,
        color: isBold ? Colors.black : Colors.grey,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
      CustomText(
        text: "$price\$",
        color: isBold ? Colors.black : Colors.grey,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    ],
  );
}
