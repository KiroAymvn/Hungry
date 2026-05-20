import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {

    //if the error came form the backend
    final statusCode=error.response!.statusCode;
    final data=error.response?.data;
    print(statusCode);
    print(data);
if(statusCode==302){
  throw ApiError(message: "Error occurred ");
}
else if (statusCode==500){
  throw ApiError(message: "Server error,try again ");

}
    if(data is Map<String,dynamic> && data["message"]!=null){
      throw ApiError(message: data["message"],statusCode: statusCode);
    }
    //if the error is exception
    switch (error.type) {
      case DioExceptionType.connectionError:
        throw ApiError(message: "Connection timeout, please check your internet.");
      case DioExceptionType.connectionTimeout:
        throw ApiError(message: "Connection timeout, please check your internet.");

      case DioExceptionType.badResponse:
        print(data);
        return ApiError(message: "Bad response: ${data["message"]?? 'Unknown'}");

     case DioExceptionType.sendTimeout:
        return ApiError(message: "Send timeout, please try again.");

      case DioExceptionType.receiveTimeout:
        return ApiError(message: "Receive timeout, please check your connection.");

      case DioExceptionType.badCertificate:
        return ApiError(message: "Bad certificate, unable to verify server.");

      case DioExceptionType.cancel:
        return ApiError(message: "Request cancelled, please try again.");

      case DioExceptionType.connectionError:
        return ApiError(message: "Connection error, please check your network.");

      case DioExceptionType.unknown:
      default:
        return ApiError(message: "An unexpected error occurred: ${error.message}");
    }
  }
}
// import 'package:dio/dio.dart';
// import 'package:hungry/core/network/api_error.dart';
//
// class ApiExceptions {
//   //function to be called at any place in try and catch to make model from error
//   static ApiError handleError(DioException error) {
//     //if the error is exception
//     switch (error.type) {
//       case DioExceptionType.connectionError:
//         return ApiError.fromJson(error.response!.data);
//       case DioExceptionType.connectionTimeout:
//         return ApiError.fromJson(error.response!.data);
//       case DioExceptionType.sendTimeout:
//         return ApiError.fromJson(error.response!.data);
//
//       case DioExceptionType.receiveTimeout:
//         return ApiError.fromJson(error.response!.data);
//
//       case DioExceptionType.badCertificate:
//         return ApiError.fromJson(error.response!.data);
//
//       case DioExceptionType.cancel:
//         return ApiError.fromJson(error.response!.data);
//
//       case DioExceptionType.connectionError:
//         return ApiError.fromJson(error.response!.data);
//       //error from user
//       case DioExceptionType.badResponse:
//         return ApiError.fromJson(error.response!.data);
//       case DioExceptionType.unknown:
//       default:
//         return ApiError.fromJson(error.response!.data);
//     }
//   }
// }
