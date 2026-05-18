import 'package:hungry/features/home/data/model/topping_model.dart';

/// All possible states for the Product Details screen.
abstract class ProductDetailsState {}

/// Before toppings are loaded.
class ProductDetailsInitial extends ProductDetailsState {}

/// While loading toppings from the API.
class ProductDetailsLoading extends ProductDetailsState {}

/// Toppings loaded, user can now customise the order.
class ProductDetailsLoaded extends ProductDetailsState {
  final List<ToppingModel> toppings;
  final List<ToppingModel> sideToppings;
  final List<int> selectedToppingIds;
  final List<int> selectedSideToppingIds;
  final double spicyLevel;

  ProductDetailsLoaded({
    required this.toppings,
    required this.sideToppings,
    required this.selectedToppingIds,
    required this.selectedSideToppingIds,
    required this.spicyLevel,
  });

  /// Creates a copy with optional overrides — useful when only selection changes.
  ProductDetailsLoaded copyWith({
    List<ToppingModel>? toppings,
    List<ToppingModel>? sideToppings,
    List<int>? selectedToppingIds,
    List<int>? selectedSideToppingIds,
    double? spicyLevel,
  }) {
    return ProductDetailsLoaded(
      toppings: toppings ?? this.toppings,
      sideToppings: sideToppings ?? this.sideToppings,
      selectedToppingIds: selectedToppingIds ?? this.selectedToppingIds,
      selectedSideToppingIds:
          selectedSideToppingIds ?? this.selectedSideToppingIds,
      spicyLevel: spicyLevel ?? this.spicyLevel,
    );
  }
}

/// Something went wrong loading toppings.
class ProductDetailsError extends ProductDetailsState {
  final String message;
  ProductDetailsError(this.message);
}

/// While the "Add to Cart" API call is running.
class AddToCartLoading extends ProductDetailsState {
  final ProductDetailsLoaded loadedData; // keep showing the details page
  AddToCartLoading(this.loadedData);
}

/// "Add to Cart" succeeded.
class AddToCartSuccess extends ProductDetailsState {
  final String message;
  final ProductDetailsLoaded loadedData;
  AddToCartSuccess(this.message, this.loadedData);
}

/// "Add to Cart" failed.
class AddToCartError extends ProductDetailsState {
  final String message;
  final ProductDetailsLoaded loadedData;
  AddToCartError(this.message, this.loadedData);
}
