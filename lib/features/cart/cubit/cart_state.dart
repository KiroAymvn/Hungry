import 'package:hungry/features/cart/data/cart_model.dart';

/// All possible states for the Cart screen.
abstract class CartState {}

/// Before any data is loaded.
class CartInitial extends CartState {}

/// While fetching or modifying the cart.
class CartLoading extends CartState {}

/// Cart loaded successfully.
class CartLoaded extends CartState {
  final List<CartItem> items;
  final double totalPrice;

  CartLoaded({required this.items, required this.totalPrice});
}

/// Something went wrong.
class CartError extends CartState {
  final String message;
  CartError(this.message);
}

/// A remove action is in progress (keeps showing items while loading).
class CartRemoveLoading extends CartState {
  final List<CartItem> items;
  final double totalPrice;

  CartRemoveLoading({required this.items, required this.totalPrice});
}
