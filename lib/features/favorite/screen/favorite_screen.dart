import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/favorite/data/favorite_model.dart';
import 'package:hungry/features/favorite/data/favorite_repo.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/network/api_error.dart';
import '../../../core/utils/pref_helper.dart';
import '../../../shared/scaffold_message_error.dart';

// Simple dummy data for UI preview

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteRepo _favoriteRepo = FavoriteRepo();
  List<FavoriteModel>? favorites;
  List<int>? favListId = [];
  List<String?> favListIdString = [];

  Future<void> toggleFavorite(int productId) async {
    try {
      final response = await _favoriteRepo.toggleFavorite(productId);

      print(response);
      if (response["message"] is ApiError) {
        scaffoldMessengerError(context, response["message"]);
      }
      scaffoldMessengerError(context, response["message"], color: Colors.green);
      if (response["code"] == 200) {
        if (favListId!.contains(productId)) {
          setState(() {
            favListId!.remove(productId);
          });
        } else {
          setState(() {
            favListId!.add(productId);
          });
        }
        await PrefHelper.setFavListId(favListId!);
        final FavList = await PrefHelper.getFavListId();

        if (!mounted) return;
        setState(() {
          favListIdString = FavList ?? [];
        });
      }
    } catch (e) {
      print(e);
      String mess = "unhandled exc";
      if (e is ApiError) {
        mess = e.toString();
      }
      scaffoldMessengerError(context, mess);
    }
  }

  Future<void> loadFavIds() async {
    final list = await PrefHelper.getFavListId();

    if (!mounted) return;

    setState(() {
      favListIdString = list ?? [];
      favListId = favListIdString.map((e) => int.parse(e!)).toList();
    });
  }

  Future<void> getFavorite() async {
    try {
      final favoriteListRes = await _favoriteRepo.get();
      if (!mounted) return;
      setState(() {
        favorites = favoriteListRes;
      });
    } catch (e) {
      print(e);
      String mess = "unhandled exc";
      if (e is ApiError) {
        mess = e.toString();
      }
      scaffoldMessengerError(context, mess);
    }
  }

  @override
  void initState() {
    getFavorite();
    loadFavIds();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,backgroundColor: AppColors.basic,),
      body: favorites == null
          ? Center(child: Lottie.asset("assets/lottie/Bouncing Burger.json", width: 100, height: 100))
          : favorites!.isEmpty
          ? Column(
              children: [
                Lottie.asset("assets/lottie/empty.json"),
                CustomText(
                  text: "No Favorites are selected ",
                  color: AppColors.primary,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(text: "Does our food isn't good to you ?", color: AppColors.secondary.withOpacity(0.3)),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites!.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = favorites![index];
                return _FavoriteCard(item: item, onToggle: () => toggleFavorite(favorites![index].id));
              },
            ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteModel item;
  void Function() onToggle;

  _FavoriteCard({required this.item, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Image
          SizedBox(
            width: 110,
            height: 110,
            child: Image.network(
              item.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + favorite icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggle,
                        child: Icon(
                          item.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Price + rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.price} EGP',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(item.rating, style: const TextStyle(fontSize: 13)),
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
