import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_service.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_exceptions.dart';
import 'favorite_model.dart';

class FavoriteRepo {

ApiService _apiService=ApiService();
  // TOGGLE FAVORITE
  Future<Map<String,dynamic>>toggleFavorite (int productId)async{
    try{
      final response = await _apiService.post("/toggle-favorite",
          {
            "product_id": productId
          }
      );
      if(response["code"]!=200){
        throw ApiError(message: response["message"]);
      }
      return response;

    }on DioException catch(e){
      throw ApiExceptions.handleError(e);
    }
    catch(e){
      throw ApiError(message: e.toString());
    }
  }


//GET FAVORTITE
  Future<List<FavoriteModel>>get ()async{
    try{
      final response = await _apiService.get("/favorites"
      );
      if(response["code"]!=200){
        throw ApiError(message: response["message"]);
      }
      return (response["data"] as List).map((e)=>FavoriteModel.fromJson(e)).toList();

    }on DioError catch(e){
      throw ApiExceptions.handleError(e);
    }
    catch(e){
      throw ApiError(message: e.toString());
    }
  }
}