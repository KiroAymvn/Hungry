import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry/features/cart/cubit/cart_state.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';

/// CartCubit fetches the cart and removes items from it.
class CartCubit extends Cubit<CartState> {
  final CartRepo _cartRepo;

  CartCubit(this._cartRepo) : super(CartInitial());

  // ─────────────────────────────────────────────
  // GET CART
  // ─────────────────────────────────────────────
  Future<void> getCart() async {
    emit(CartLoading());
    try {
      final cartResponse = await _cartRepo.getCart();
      if (cartResponse == null) {
        emit(CartLoaded(items: [], totalPrice: 0));
        return;
      }
      final items = cartResponse.cartData.itemList;
      final total = _calculateTotal(items);
      emit(CartLoaded(items: items, totalPrice: total));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ─────────────────────────────────────────────
  // REMOVE ITEM
  // ─────────────────────────────────────────────
  Future<void> removeFromCart(int itemId) async {
    // Show a spinner while still displaying the current list
    if (state is CartLoaded) {
      final current = state as CartLoaded;
      emit(CartRemoveLoading(
        items: current.items,
        totalPrice: current.totalPrice,
      ));
    }
    try {
      await _cartRepo.removeCartItem(itemId);
      // Reload the full cart after removal
      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────
  double _calculateTotal(List<CartItem> items) {
    double total = 0;
    for (final item in items) {
      total += item.quantity * (double.tryParse(item.price.toString()) ?? 0);
    }
    return total;
  }
}
