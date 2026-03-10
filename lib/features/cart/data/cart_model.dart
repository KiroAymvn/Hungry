import 'package:hungry/features/home/data/model/topping_model.dart';
//send to backend
class CartModel {
  final int productId;
  final int quantity;

  final double spicy;
  final List<int> topping;
  final List<int> sideOptions;

  CartModel({
    required this.productId,
    required this.quantity,
    required this.spicy,
    required this.topping,
    required this.sideOptions,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'spicy': spicy,
      'toppings': topping,
      'side_options': sideOptions,
    };
  }
}

class CartRequestModel {
  final List<CartModel> items;

  CartRequestModel({required this.items});

  Map<String, dynamic> toJson() {
    return {
      // to convert every model in List <CartModel> to json so to covert each model it has to pass
      //over each item and convert it to json
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}


//get from backend
class GetCartResponse{
  final int code;
  final String message;
  final CartData cartData;

  GetCartResponse({required this.code, required this.message, required this.cartData});

  factory GetCartResponse.fromMap(Map<String, dynamic> json) {
    return GetCartResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      //because of cartData is not found in the response and i create it so i have to et the path
      // of the model from the real response
      cartData: CartData.fromJson(json["data"]),
    );
  }}
class CartData{
  final int id;
  final String price;
  final List<CartItem> itemList;

  CartData({required this.id, required this.price, required this.itemList});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'] as int,
      price: json['total_price'] as String,
      itemList: (json["items"]as List).map((e)=>CartItem.fromJson(e)).toList(),
    );
  }}

class CartItem {
  final int itemId;
  final int productId;
  final String name;
  final String image;
  final int quantity;

  final String price;
  final double spicy;
  final List<ToppingModel> toppingList;
  final List<ToppingModel> sideToppingList;

  CartItem({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.spicy,
    required this.toppingList,
    required this.sideToppingList,
  });


  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      itemId: json['item_id'] as int,
      productId: json['product_id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as String,
      spicy: double.tryParse(json["spicy"].toString())??0.0,
      // I list full of Json
      // My goal is to convert every item in the list to be models
      //so i have to pass over each it  "e" and convert it by function fromJson(e) t model
      //then return the list of model
      toppingList: (json['toppings'] as List).map((e)=>ToppingModel.fromJson(e)).toList(),
      sideToppingList: (json['side_options'] as List).map((e)=>ToppingModel.fromJson(e)).toList(),
    );
  }
}



