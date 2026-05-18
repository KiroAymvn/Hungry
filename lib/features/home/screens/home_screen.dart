import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/home/cubit/home_cubit.dart';
import 'package:hungry/features/home/cubit/home_state.dart';
import 'package:hungry/features/home/widgets/custom_card.dart';
import 'package:hungry/features/home/widgets/custom_food_categories.dart';
import 'package:hungry/features/productDetails/screens/product_details_screen.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/custom_search_field.dart';
import '../widgets/custom_user_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> _categories = [
    'All',
    'Combo',
    'Classic',
    'Classic',
    'Classic',
    'Classic',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // Show error snack bar if something goes wrong
        if (state is HomeError) {
          scaffoldMessengerError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is HomeLoading || state is HomeInitial;
        final products =
            state is HomeLoaded ? state.products : [];
        final favIds =
            state is HomeLoaded ? state.favoriteIds : <int>[];

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Skeletonizer(
                enabled: isLoading,
                enableSwitchAnimation: true,
                child: CustomScrollView(
                  slivers: [
                    // ── APP BAR + SEARCH ─────────────────────────
                    SliverAppBar(
                      pinned: false,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      automaticallyImplyLeading: false,
                      backgroundColor: AppColors.basic,
                      toolbarHeight: 190,
                      flexibleSpace: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20),
                        child: Column(
                          children: [
                            const Gap(50),
                            const CustomUserHeader(),
                            const Gap(10),
                            const CustomSearchField(),
                          ],
                        ),
                      ),
                    ),
                    // ── CATEGORIES ───────────────────────────────
                    SliverToBoxAdapter(
                      child: CustomFoodCategories(
                        categories: _categories,
                        selectedCategory: 0,
                      ),
                    ),
                    // ── PRODUCT GRID ──────────────────────────────
                    SliverPadding(
                      padding: const EdgeInsets.all(8),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Show placeholder skeleton cards while loading
                            if (isLoading) {
                              return Skeleton.leaf(
                                child: CustomCard(
                                  onTapFav: () {},
                                  image: '',
                                  title: '',
                                  price: '0',
                                  rate: '',
                                  productId: 0,
                                  favListId: [],
                                ),
                              );
                            }
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsScreen(
                                        product: product),
                                  ),
                                );
                              },
                              child: CustomCard(
                                isFavorite: favIds.contains(product.id),
                                onTapFav: () => context
                                    .read<HomeCubit>()
                                    .toggleFavorite(product.id),
                                image: product.image,
                                title: product.name,
                                price: product.price,
                                rate: product.rating,
                                productId: product.id,
                                favListId: favIds,
                              ),
                            );
                          },
                          childCount: isLoading ? 6 : products.length,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
