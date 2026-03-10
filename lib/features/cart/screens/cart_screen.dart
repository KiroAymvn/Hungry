import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/utils/pref_helper.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/checkout/screens/checkout_screen.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/custom_add_or_minus_button.dart';
import '../widgets/cutsom_cart_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int number = 0;
  GetCartResponse? cartResponse;
  List<CartItem> cartItems = [];
  CartData? cartData;
  CartRepo _cartRepo = CartRepo();
  bool isLoading = false;

  //get cart
  Future<void> getCart() async {
    try {
      setState(() {
        isLoading = true;
      });
      final cartModel = await _cartRepo.getCart();
      if (!mounted) return;
      setState(() {
        cartResponse = cartModel;
        cartData = cartModel!.cartData;
        cartItems = cartModel.cartData.itemList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      String errorMess = "unhandled exp";
      if (e is ApiError) {
        errorMess = e.toString();
      }
      scaffoldMessengerError(context, errorMess);
    }
  }

  bool removeLoading = false;

  //remove
  Future<void> removeFromCart(int itemId) async {
    try {
      setState(() {
        removeLoading = true;
      });
      final response = await _cartRepo.removeCartItem(itemId);
      if (response["code"] == 200) {
        scaffoldMessengerError(context, response["message"].toString(), color: Colors.green);
      }
      setState(() {
        removeLoading = false;
        getCart();
      });
    } catch (e) {
      setState(() {
        removeLoading = false;
      });
      String errorMess = "unhandled exp";
      if (e is ApiError) {
        errorMess = e.toString();
      }
      scaffoldMessengerError(context, errorMess);
    }
  }

  double? totalPrice() {
    double? total = 0;
    for (int i = 0; i < cartItems.length; i++) {
      total = (total! + (cartItems[i].quantity * double.tryParse((cartItems[i].price).toString())!.toDouble()));
    }
    return total;
  }

  @override
  void initState() {
    getCart().then((e) {
      totalPrice();
    });
    super.initState();
  }
AuthRepo authRepo=AuthRepo();
  @override
  Widget build(BuildContext context) {
    return
         isLoading
             ? Center(child: Lottie.asset("assets/lottie/Bouncing Burger.json", width: 100, height: 100))
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CustomCartCard(
                    image: item.image,
                    title: item.name,
                    desc: item.price,
                    number: item.quantity,
                    onRemove: () => removeFromCart(item.itemId),
                  );
                },
              ),
            ),
            bottomSheet: Container(
              height: 200,
              decoration: BoxDecoration(borderRadius: BorderRadiusGeometry.circular(20)),
              padding: EdgeInsetsGeometry.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Total", color: Colors.black, fontSize: 22),
                      CustomText(
                        text: "\$ ${totalPrice()}",
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ],
                  ),
                  CustomButton(
                    text: "CheckOut",
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen()));
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
