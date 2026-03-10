import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/core/network/dio_client.dart';

class ApiService {
  DioClient _dioClient = DioClient();

  //CRUD methods

  //get
  Future<dynamic> get(String endpoint) async {
    try {
      final Response response = await _dioClient.dio.get(endpoint);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  //post
  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final Response response = await _dioClient.dio.post(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  //put / update
  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final Response response = await _dioClient.dio.put(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  //delete
  Future<dynamic> delete(String endpoint, Map<String, dynamic> body, {dynamic? parameter}) async {
    try {
      final Response response = await _dioClient.dio.delete(endpoint, data: body, );
      return response.data;
    } on DioException catch (e) {
      return ApiExceptions.handleError(e);
    }
  }
}
