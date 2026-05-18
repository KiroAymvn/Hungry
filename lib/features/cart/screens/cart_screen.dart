import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/cubit/cart_cubit.dart';
import 'package:hungry/features/cart/cubit/cart_state.dart';
import 'package:hungry/features/checkout/screens/checkout_screen.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import 'package:lottie/lottie.dart';

import '../widgets/cutsom_cart_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          scaffoldMessengerError(context, state.message);
        }
      },
      builder: (context, state) {
        // ── LOADING ─────────────────────────────────────────
        if (state is CartLoading) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/Bouncing Burger.json',
              width: 100,
              height: 100,
            ),
          );
        }

        // ── DETERMINE ITEMS LIST (also works for CartRemoveLoading) ──
        final items = state is CartLoaded
            ? state.items
            : state is CartRemoveLoading
                ? state.items
                : [];

        final totalPrice = state is CartLoaded
            ? state.totalPrice
            : state is CartRemoveLoading
                ? state.totalPrice
                : 0.0;

        final isRemoving = state is CartRemoveLoading;

        // ── CART CONTENT ─────────────────────────────────────
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottie/empty.json',
                            width: 200),
                        CustomText(
                          text: 'Your cart is empty',
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return CustomCartCard(
                        image: item.image,
                        title: item.name,
                        desc: item.price,
                        number: item.quantity,
                        onRemove: isRemoving
                            ? null // disable while a remove is in progress
                            : () => context
                                .read<CartCubit>()
                                .removeFromCart(item.itemId),
                      );
                    },
                  ),
          ),
          bottomSheet: Container(
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Total price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        text: 'Total', color: Colors.black, fontSize: 22),
                    CustomText(
                      text: '\$ ${totalPrice.toStringAsFixed(2)}',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ],
                ),
                // Checkout button
                isRemoving
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: 'CheckOut',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CheckoutScreen()),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
