import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/home/data/model/product_model.dart';
import 'package:hungry/features/home/data/model/topping_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
import 'package:hungry/features/productDetails/screens/product_details_screen.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/scaffold_message_error.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/custom_product_card.dart';
import '../widgets/custom_spicy_slider.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  CartRepo _cartRepo = CartRepo();
  double value = 0;
  ProductRepo _productRepo = ProductRepo();
  List<ToppingModel?> toppingList = [];
  List<ToppingModel?> sideToppingList = [];
  int? selectedTopping;
  List<int> selectedToppingList = [];
  List<int> selectedSideToppingList = [];
  bool cartLoading = false;

  Future<void> getToppings() async {
    try {
      final List<ToppingModel?> toppings = await _productRepo.getToppings();
      if (!mounted) return;
      setState(() {
        toppingList = toppings;
      });
    } catch (e) {
      String errorMess = "unhandeled excptions";
      if (e is ApiError) {
        errorMess = e.toString();
      }
      scaffoldMessengerError(context, errorMess);
    }
  }

  Future<void> getSideToppings() async {
    try {
      final toppings = await _productRepo.getSideTopping();
      if (!mounted) return;
      setState(() {
        sideToppingList = toppings;
      });
    } catch (e) {
      String errorMess = "unhandeled excptions";
      if (e is ApiError) {
        errorMess = e.toString();
      }
      scaffoldMessengerError(context, errorMess);
    }
  }

  Future<void> addToCart(CartModel cartItem)async{
    try{
      setState(() {
        cartLoading = true;
      });

      final cart=await _cartRepo.addToCart(CartRequestModel(items: [cartItem]));
      setState(() {
        cartLoading = false;
      });
      scaffoldMessengerError(context, cart["message"],color: Colors.green);
    }
        catch(e){
          setState(() {
            cartLoading = false;
          });
      scaffoldMessengerError(context, e.toString());
        }
  }

  @override
  void initState() {
    getToppings();
    getSideToppings();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Skeletonizer(
        enabled: toppingList.isEmpty && sideToppingList.isEmpty ,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //IMAGE+SLIDER+TEXT
                CustomSpicySlider(
                  productModel: widget.product,
                  onChanged: (v) {
                    setState(() {
                      value = v;
                    });
                  },
                  value: value,
                ),
                Gap(20),
                //TOPPING CARDS
                CustomText(text: "Toppings", color: Colors.black, fontSize: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(toppingList?.length ?? 4, (index) {
                      final topping = toppingList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedToppingList.contains(topping.id)) {
                              selectedToppingList.remove(topping.id);
                            } else {
                              selectedToppingList.add(topping.id);
                            }
                          });
                        },
                        child: CustomProductCard(topping: topping!, id: topping.id, selectedItem: selectedToppingList),
                      );
                    }).toList(),
                  ),
                ),
                Gap(20),
                //OPTIONS
                CustomText(text: "Side Dishes", color: Colors.black, fontSize: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(sideToppingList?.length ?? 4, (index) {
                      final sideTopping = sideToppingList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedSideToppingList.contains(sideTopping.id)) {
                              selectedSideToppingList.remove(sideTopping.id);
                            } else {
                              selectedSideToppingList.add(sideTopping.id);
                            }
                          });
                        },
                        child: CustomProductCard(
                          topping: sideTopping!,
                          id: sideTopping.id,
                          selectedItem: selectedSideToppingList,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Gap(20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Total", color: Colors.black, fontSize: 22),
                        CustomText(text: "\$18.79", color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async{
                        final cartItem = CartModel(
                          productId: widget.product.id,
                          quantity: 1,
                          spicy: value ==0 ? 0.1:value,
                          topping: selectedToppingList,
                          sideOptions: selectedSideToppingList,
                        );
                      await  addToCart(cartItem);
                      },
                      child: Container(
                        width: 200,
                        height: 75,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                        child: Center(
                          child: cartLoading
                              ? CircularProgressIndicator()
                              : CustomText(text: "Add To Cart", fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
