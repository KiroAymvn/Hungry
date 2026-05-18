import 'package:hungry/features/home/data/model/product_model.dart';

/// All possible states for the Home screen.
abstract class HomeState {}

/// Before any data is loaded.
class HomeInitial extends HomeState {}

/// While fetching products from the API.
class HomeLoading extends HomeState {}

/// Products loaded successfully.
class HomeLoaded extends HomeState {
  final List<ProductModel> products;
  final List<int> favoriteIds; // IDs of products the user liked

  HomeLoaded({required this.products, required this.favoriteIds});

  /// Creates a copy with optional overrides — useful when only favs change.
  HomeLoaded copyWith({
    List<ProductModel>? products,
    List<int>? favoriteIds,
  }) {
    return HomeLoaded(
      products: products ?? this.products,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

/// Something went wrong.
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
