import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/core/utils/pref_helper.dart';
import 'package:hungry/features/favorite/data/favorite_repo.dart';
import 'package:hungry/features/home/cubit/home_state.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';

/// HomeCubit fetches the product list and handles favorite toggling.
class HomeCubit extends Cubit<HomeState> {
  final ProductRepo _productRepo;
  final FavoriteRepo _favoriteRepo;

  HomeCubit(this._productRepo, this._favoriteRepo) : super(HomeInitial());

  // ─────────────────────────────────────────────
  // LOAD PRODUCTS + FAV IDS
  // ─────────────────────────────────────────────
  Future<void> loadHome() async {
    emit(HomeLoading());
    try {
      // fetch products and saved fav ids at the same time
      final results = await Future.wait([
        _productRepo.getProduct('/products'),
        _loadFavIds(),
      ]);

      final products = results[0] as dynamic;
      final favIds = results[1] as List<int>;

      emit(HomeLoaded(products: products, favoriteIds: favIds));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  /// Reads favorite IDs from SharedPreferences.
  Future<List<int>> _loadFavIds() async {
    final rawList = await PrefHelper.getFavListId();
    if (rawList == null) return [];
    return rawList.map((e) => int.parse(e)).toList();
  }

  // ─────────────────────────────────────────────
  // TOGGLE FAVORITE
  // ─────────────────────────────────────────────
  Future<void> toggleFavorite(int productId) async {
    // Only do something if products are already loaded
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;

    try {
      final response = await _favoriteRepo.toggleFavorite(productId);

      if (response['code'] == 200) {
        // update the local list
        final updatedFavIds = List<int>.from(currentState.favoriteIds);
        if (updatedFavIds.contains(productId)) {
          updatedFavIds.remove(productId);
        } else {
          updatedFavIds.add(productId);
        }

        // save to SharedPreferences
        await PrefHelper.setFavListId(updatedFavIds);

        // emit updated state
        emit(currentState.copyWith(favoriteIds: updatedFavIds));
      }
    } catch (e) {
      // Don't change the products list on error — just report it
      emit(HomeError(e.toString()));
      // Re-emit the old state so the UI stays usable
      emit(currentState);
    }
  }
}
