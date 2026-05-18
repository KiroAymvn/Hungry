import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/home/data/model/product_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
import 'package:hungry/features/productDetails/cubit/product_details_cubit.dart';
import 'package:hungry/features/productDetails/cubit/product_details_state.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/custom_product_card.dart';
import '../widgets/custom_spicy_slider.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create a fresh cubit for this screen and immediately load toppings
      create: (_) =>
          ProductDetailsCubit(ProductRepo(), CartRepo())..loadToppings(),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          // Show snack bar after add-to-cart succeeds or fails
          if (state is AddToCartSuccess) {
            scaffoldMessengerError(context, state.message,
                color: Colors.green);
          } else if (state is AddToCartError) {
            scaffoldMessengerError(context, state.message);
          }
        },
        builder: (context, state) {
          // ── EXTRACT CURRENT DATA FROM STATE ─────────────────
          final isLoadingToppings = state is ProductDetailsLoading ||
              state is ProductDetailsInitial;
          final isAddingToCart = state is AddToCartLoading;

          // Get the loaded data regardless of whether add-to-cart is running
          ProductDetailsLoaded? loaded;
          if (state is ProductDetailsLoaded) loaded = state;
          if (state is AddToCartLoading) loaded = state.loadedData;
          if (state is AddToCartSuccess) loaded = state.loadedData;
          if (state is AddToCartError) loaded = state.loadedData;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back),
              ),
            ),
            body: Skeletonizer(
              enabled: isLoadingToppings,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── PRODUCT IMAGE + SPICY SLIDER ──────────
                      CustomSpicySlider(
                        productModel: product,
                        onChanged: (v) {
                          context
                              .read<ProductDetailsCubit>()
                              .changeSpicyLevel(v);
                        },
                        value: loaded?.spicyLevel ?? 0,
                      ),
                      const Gap(20),

                      // ── TOPPINGS ──────────────────────────────
                      CustomText(
                          text: 'Toppings',
                          color: Colors.black,
                          fontSize: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            loaded?.toppings.length ?? 4,
                            (index) {
                              final topping = loaded?.toppings[index];
                              if (topping == null) return const SizedBox();
                              return GestureDetector(
                                onTap: () => context
                                    .read<ProductDetailsCubit>()
                                    .toggleTopping(topping.id),
                                child: CustomProductCard(
                                  topping: topping,
                                  id: topping.id,
                                  selectedItem:
                                      loaded?.selectedToppingIds ?? [],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Gap(20),

                      // ── SIDE DISHES ───────────────────────────
                      CustomText(
                          text: 'Side Dishes',
                          color: Colors.black,
                          fontSize: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            loaded?.sideToppings.length ?? 4,
                            (index) {
                              final side = loaded?.sideToppings[index];
                              if (side == null) return const SizedBox();
                              return GestureDetector(
                                onTap: () => context
                                    .read<ProductDetailsCubit>()
                                    .toggleSideTopping(side.id),
                                child: CustomProductCard(
                                  topping: side,
                                  id: side.id,
                                  selectedItem:
                                      loaded?.selectedSideToppingIds ?? [],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Gap(20),

                      // ── TOTAL + ADD TO CART ───────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                  text: 'Total',
                                  color: Colors.black,
                                  fontSize: 22),
                              CustomText(
                                  text: '\$${product.price}',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ],
                          ),
                          GestureDetector(
                            onTap: isAddingToCart
                                ? null // prevent double-tap while loading
                                : () {
                                    final cartItem = CartModel(
                                      productId: product.id,
                                      quantity: 1,
                                      spicy: (loaded?.spicyLevel ?? 0) == 0
                                          ? 0.1
                                          : (loaded?.spicyLevel ?? 0.1),
                                      topping:
                                          loaded?.selectedToppingIds ?? [],
                                      sideOptions:
                                          loaded?.selectedSideToppingIds ??
                                              [],
                                    );
                                    context
                                        .read<ProductDetailsCubit>()
                                        .addToCart(cartItem);
                                  },
                            child: Container(
                              width: 200,
                              height: 75,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: isAddingToCart
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : CustomText(
                                        text: 'Add To Cart',
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
