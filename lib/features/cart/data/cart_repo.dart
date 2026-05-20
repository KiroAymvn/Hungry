import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/features/cart/data/cart_model.dart';

class CartRepo {
  ApiService _apiService = ApiService();

  //ADD TO CART
  Future<Map<String, dynamic>> addToCart(CartRequestModel cartRequest) async {
    try {
      final response = await _apiService.post("/cart/add", cartRequest.toJson());
      // if(response["code"]!=200 || response["code"]!=201){
      //   throw ApiError(message: response["message"]);
      // }
      return response;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      if (e is ApiError) throw e;
      throw ApiError(message: e.toString());
    }
  }

  Future<GetCartResponse?> getCart() async {
    try {
      final response = await _apiService.get("/cart");
      final cartModel = GetCartResponse.fromMap(response);
      if (cartModel.code != 200) {
        throw ApiError(message: cartModel.message.toString());
      }
      return cartModel;
    } on DioError catch (e) {
      throw ApiError(message: e.toString());
    } catch (e) {
      if (e is ApiError) throw e;
      throw ApiError(message: e.toString());
    }
  }

  Future<Map<String,dynamic>> removeCartItem(int itemId) async {
    try {
      final response = await _apiService.delete("/cart/remove/$itemId", {},);
      if (response["code"] != 200) {
        throw ApiError(message: response["message"]);
      }
      return response;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      if (e is ApiError) throw e;
      throw ApiError(message: e.toString());
    }
  }
}
