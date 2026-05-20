import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/features/favorite/data/favorite_model.dart';
import 'package:hungry/features/home/data/model/product_model.dart';

import '../model/topping_model.dart';

class ProductRepo {
  ApiService _apiService=ApiService();


  //GET PRODUCT
  Future<List<ProductModel>> getProduct(String endpoint) async{
    try{
      final response= await _apiService.get(endpoint);
      if(response is ApiError){
        throw response;
      }
      if(response["code"]!=200){
        final mess=response["message"];
        throw ApiError(message: mess);
      }
      final List<dynamic> products=response["data"];
      return products.map((json)=>ProductModel.fromJson(json)).toList();
    }on DioError catch (e){
      throw ApiExceptions.handleError(e);
    }catch(e){
      if (e is ApiError) throw e;
      throw ApiError(message: e.toString());
    }

  }

//GET TOPPINGS
Future<List<ToppingModel?>> getToppings()async{
    try{
      final response =await _apiService.get("/toppings");
      final List<dynamic> toppings=response["data"] as List;
      if(response is ApiError){
        throw response;
      }
      if(response["code"]!=200){
        throw ApiError(message: "error occurd");
      }
      return toppings.map((e)=>ToppingModel.fromJson(e)).toList();
    }on DioError catch(e){
      throw ApiExceptions.handleError(e);
    }catch(e){
      if (e is ApiError) throw e;
      throw ApiError(message: e.toString());
    }
}

//GET SIDE TOPPING
Future<List<ToppingModel>> getSideTopping()async{
    try{
      final response=await _apiService.get("/side-options");
      return (response["data"] as List).map((e)=>ToppingModel.fromJson(e)).toList();
    }on DioError catch (e){
      throw ApiExceptions.handleError(e);
    }catch(e){
      if (e is ApiError) throw e;
      throw ApiError(message: e.toString());
    }

}





  //SEARCH


//CATEGORY

}