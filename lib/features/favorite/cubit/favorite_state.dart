import 'package:hungry/features/favorite/data/favorite_model.dart';

/// All possible states for the Favorites screen.
abstract class FavoriteState {}

/// Before any data is loaded.
class FavoriteInitial extends FavoriteState {}

/// While fetching favorites from the API.
class FavoriteLoading extends FavoriteState {}

/// Favorites loaded successfully.
class FavoriteLoaded extends FavoriteState {
  final List<FavoriteModel> favorites;
  FavoriteLoaded(this.favorites);
}

/// Something went wrong.
class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
}
