import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/utils/pref_helper.dart';
import 'package:hungry/features/favorite/cubit/favorite_state.dart';
import 'package:hungry/features/favorite/data/favorite_repo.dart';

/// FavoriteCubit fetches the favorites list and handles toggling.
class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepo _favoriteRepo;

  FavoriteCubit(this._favoriteRepo) : super(FavoriteInitial());

  // ─────────────────────────────────────────────
  // GET FAVORITES
  // ─────────────────────────────────────────────
  Future<void> getFavorites() async {
    emit(FavoriteLoading( ));
    try {
      final favorites = await _favoriteRepo.get();
      emit(FavoriteLoaded(favorites));
    } catch (e) {
      if(e is ApiError){
      emit(FavoriteError(e.message!));

      }
      else{
         emit(FavoriteError("حدث خطأ أثناء تحميل المفضلة",));
      }
    }
  }

  // ─────────────────────────────────────────────
  // TOGGLE FAVORITE
  // ─────────────────────────────────────────────
  Future<void> toggleFavorite(int productId) async {
    // Keep the current list visible while the request is happening
    if (state is! FavoriteLoaded) return;
    final currentState = state as FavoriteLoaded;

    try {
      final response = await _favoriteRepo.toggleFavorite(productId);

      if (response['code'] == 200) {
        // Reload the list so the UI is up to date
        await getFavorites();

        // Also update SharedPreferences with the new list
        final updatedIds = currentState.favorites
            .where((f) => f.isFavorite)
            .map((f) => f.id)
            .toList();
        await PrefHelper.setFavListId(updatedIds);
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
      // Restore the previous state so the screen stays usable
      emit(currentState);
    }
  }
}
