import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/home/data/model/topping_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
import 'package:hungry/features/productDetails/cubit/product_details_state.dart';

/// ProductDetailsCubit loads toppings and handles the add-to-cart action.
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductRepo _productRepo;
  final CartRepo _cartRepo;

  ProductDetailsCubit(this._productRepo, this._cartRepo)
      : super(ProductDetailsInitial());

  // ─────────────────────────────────────────────
  // LOAD TOPPINGS
  // ─────────────────────────────────────────────
  Future<void> loadToppings() async {
    emit(ProductDetailsLoading());
    try {
      // Load both toppings lists at the same time to save time
      final toppings = await _productRepo.getToppings();
      final sideToppings = await _productRepo.getSideTopping();

      emit(ProductDetailsLoaded(
        toppings: toppings.whereType<ToppingModel>().toList(),
        sideToppings: sideToppings,
        selectedToppingIds: [],
        selectedSideToppingIds: [],
        spicyLevel: 0,
      ));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  // ─────────────────────────────────────────────
  // TOGGLE TOPPING SELECTION
  // ─────────────────────────────────────────────
  void toggleTopping(int toppingId) {
    if (state is! ProductDetailsLoaded) return;
    final current = state as ProductDetailsLoaded;

    final updated = List<int>.from(current.selectedToppingIds);
    if (updated.contains(toppingId)) {
      updated.remove(toppingId);
    } else {
      updated.add(toppingId);
    }

    emit(current.copyWith(selectedToppingIds: updated));
  }

  // ─────────────────────────────────────────────
  // TOGGLE SIDE TOPPING SELECTION
  // ─────────────────────────────────────────────
  void toggleSideTopping(int sideToppingId) {
    if (state is! ProductDetailsLoaded) return;
    final current = state as ProductDetailsLoaded;

    final updated = List<int>.from(current.selectedSideToppingIds);
    if (updated.contains(sideToppingId)) {
      updated.remove(sideToppingId);
    } else {
      updated.add(sideToppingId);
    }

    emit(current.copyWith(selectedSideToppingIds: updated));
  }

  // ─────────────────────────────────────────────
  // CHANGE SPICY LEVEL
  // ─────────────────────────────────────────────
  void changeSpicyLevel(double value) {
    if (state is! ProductDetailsLoaded) return;
    final current = state as ProductDetailsLoaded;
    emit(current.copyWith(spicyLevel: value));
  }

  // ─────────────────────────────────────────────
  // ADD TO CART
  // ─────────────────────────────────────────────
  Future<void> addToCart(CartModel cartItem) async {
    if (state is! ProductDetailsLoaded) return;
    final currentLoaded = state as ProductDetailsLoaded;

    emit(AddToCartLoading(currentLoaded));
    try {
      final response =
          await _cartRepo.addToCart(CartRequestModel(items: [cartItem]));
      final message = response['message']?.toString() ?? 'Added to cart!';
      emit(AddToCartSuccess(message, currentLoaded));
    } catch (e) {
      emit(AddToCartError(e.toString(), currentLoaded));
    }
  }
}
