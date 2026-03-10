import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'check_out_widget.dart';

class CustomOrderDetails extends StatelessWidget {
  const CustomOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          checkOutWidget("order", 18, false),
          Gap(10),
          checkOutWidget("Taxes", 3.5, false),
          Gap(10),
          checkOutWidget("Delivery fees", 2.4, false),
          Gap(10),
          Divider(),
          checkOutWidget("Total", 100, true),
        ],

    );
  }
}
