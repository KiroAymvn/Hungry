import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/core/utils/pref_helper.dart';
import 'package:hungry/features/auth/data/user_model.dart';

class AuthRepo {
  ApiService _apiService = ApiService();
  bool isGuest = false;
  UserModel? _currentUser;

  //Login
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await _apiService.post("/login", {"email": email, "password": password});
      //if the response is ApiError throw it to the catch
      if (response is ApiError) {
        throw response;
      }
      print(response["message"]);
      if (response is Map<String, dynamic>) {
        final msg = response["message"];
        final coder = response["code"];
        final data = response["data"];
        if (coder != 200 || data == null) {
          throw ApiError(message: msg);
        }

      }
      final user = UserModel.fromJson(response["data"]);

      if (user.token != null) {
        await PrefHelper.saveToken(user.token!);
      }
      isGuest = false;
      _currentUser = user;
      // await saveLogged(isLoggedIn);
      // await PrefHelper.saveGuest(isGuest);
      return user;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
       // If it's already an ApiError, just pass it up to the Cubit exactly as it is!
      if (e is ApiError) {
        throw e; 
      }
      // If it's some other random error, wrap it.
      throw ApiError(message: e.toString());
    }
  }

  //Register
  Future<UserModel?> register({required String name, required String email, required String password}) async {
    try {
      final response = await _apiService.post("/register", {"name": name, "email": email, "password": password});

      if (response is ApiError) {
        throw response;
      }

      //to be able to get all the data send from the backend
      if (response is Map<String, dynamic>) {
        final msg = response["message"];
        final code = int.tryParse(response["code"]);

        final data = response["data"];
        // if (code != 200 || code != 201) {
        //   throw ApiError(message: msg);
        // }
      }

      final user = UserModel.fromJson(response["data"]);
      if (user.token != null) {
        await PrefHelper.saveToken(user.token!);
      }
      print(user.token);
      isGuest = false;
      _currentUser = user;
      // await saveLogged(isLoggedIn);
      // await PrefHelper.saveGuest(isGuest);

      return user;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      if (e is ApiError) throw e;
      throw ApiError(message: e.toString());
    }
  }

  //Get Profile data
  Future<UserModel?> getProfileData() async {
    try {
      //if the user do not have an account or he is a guest return null
      final token = await PrefHelper.getToken();
      if (token == null || token == "guest") {
        return null;
      }
      final response = await _apiService.get("/profile");
      final user = UserModel.fromJson(response["data"]);
      print("USER TOKE IS ${user.token}");
      isGuest = false;
      _currentUser = user;
      // await saveLogged(isLoggedIn);
      // await PrefHelper.saveGuest(isGuest);


      return user;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      if (e is ApiError) throw e;
      throw ApiError(message: e.toString());
    }
  }

  //Update
  Future<UserModel?> updateProfileData({
    String? name,
    String? email,
    String? phone,
    String? image,
    String? address,
    String? visa,
  }) async {
    try {
      //the backend wants the data in form of FormData not body or map so send it in Form Data
      final formData = FormData.fromMap({
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        if (image != null && image.isNotEmpty) "image": await MultipartFile.fromFile(image, filename: "profile.jpg"),

        if (visa != null && visa.isNotEmpty) "Visa": visa,
      });
      final response = await _apiService.post("/update-profile", formData);
      final user = UserModel.fromJson(response["data"]);
      if (response is ApiError) {
        throw response;
      }
      print(response["message"]);
      if (response is Map<String, dynamic>) {
        final msg = response["message"];
        final code = response["code"];
        final data = response["data"];
        if (code != 200 || data == null) {
          throw ApiError(message: msg);
        }
      }
      isGuest = false;
      _currentUser = user;
      // await saveLogged(isLoggedIn);
      // await PrefHelper.saveGuest(isGuest);

      return user;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      if (e is ApiError) throw e;
      throw ApiError(message: e.toString());
    }
  }

  //Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _apiService.post("/logout", {});
      if (response["data"] != null) {
        throw ApiError(message: "error in logout");
      }

      await PrefHelper.clearToken();
      print(response);
      isGuest = true;
      _currentUser = null;
      // await saveLogged(isLoggedIn);
      // await PrefHelper.saveGuest(isGuest);

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  //Auto Login
  Future<UserModel?> autoLogin() async {
    final token = await PrefHelper.getToken();
    if (token == null || token == "guest") {
      _currentUser = null;
      isGuest = true;
      return null;
    }
    isGuest=false;
    try {
      final user = await getProfileData();
      _currentUser = user;
      return user;
    } catch (e) {
      await PrefHelper.clearToken();
      isGuest = true;
      _currentUser = null;
      return null;
    }
  }

  //Continue as a guest
  Future<void> continueAsAGuest() async {
    _currentUser = null;
    isGuest = true;
    await PrefHelper.saveToken("guest");
    // await saveLogged(isLoggedIn);
    // await PrefHelper.saveGuest(isGuest);

  }

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => !isGuest && _currentUser != null;
// Future<void> saveLogged(bool isLogged)async{
//   await PrefHelper.saveLogged(isLogged);
// }

}
