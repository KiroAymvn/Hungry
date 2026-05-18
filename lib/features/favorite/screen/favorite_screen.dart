import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/favorite/cubit/favorite_cubit.dart';
import 'package:hungry/features/favorite/cubit/favorite_state.dart';
import 'package:hungry/features/favorite/data/favorite_model.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import 'package:lottie/lottie.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteError) {
          scaffoldMessengerError(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.basic,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, FavoriteState state) {
    // ── LOADING ─────────────────────────────────────────────────
    if (state is FavoriteLoading || state is FavoriteInitial) {
      return Center(
        child: Lottie.asset(
          'assets/lottie/Bouncing Burger.json',
          width: 100,
          height: 100,
        ),
      );
    }

    // ── ERROR ────────────────────────────────────────────────────
    if (state is FavoriteError) {
      return Center(
        child: CustomText(
          text: state.message,
          color: Colors.red,
        ),
      );
    }

    // ── LOADED ───────────────────────────────────────────────────
    if (state is FavoriteLoaded) {
      final favorites = state.favorites;

      if (favorites.isEmpty) {
        return Column(
          children: [
            Lottie.asset('assets/lottie/empty.json'),
            CustomText(
              text: 'No Favorites are selected',
              color: AppColors.primary,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: "Does our food isn't good to you?",
              color: AppColors.secondary.withOpacity(0.3),
            ),
          ],
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: favorites.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = favorites[index];
          return _FavoriteCard(
            item: item,
            onToggle: () =>
                context.read<FavoriteCubit>().toggleFavorite(item.id),
          );
        },
      );
    }

    return const SizedBox();
  }
}

// ── FAVORITE CARD WIDGET ─────────────────────────────────────────────
class _FavoriteCard extends StatelessWidget {
  final FavoriteModel item;
  final VoidCallback onToggle;

  const _FavoriteCard({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // ── PRODUCT IMAGE ──────────────────────────────────
          SizedBox(
            width: 110,
            height: 110,
            child: item.image.isEmpty
                ? Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  )
                : Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
          ),
          // ── PRODUCT INFO ───────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggle,
                        child: Icon(
                          item.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.price} EGP',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(item.rating,
                              style:
                                  const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
