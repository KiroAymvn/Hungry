
import 'dart:core' ;

import 'package:shared_preferences/shared_preferences.dart';
class PrefHelper {
  static const String keyToken="auth_token";

  static Future <void> saveToken(String token)async{
    final pref= await SharedPreferences.getInstance();
    await pref.setString(keyToken, token);
  }
  static Future <String?> getToken()async{
    final pref= await SharedPreferences.getInstance();
   return pref.getString(keyToken);

  }
  static Future<void> clearToken() async{
    final pref=await SharedPreferences.getInstance();
    pref.remove(keyToken);
  }

  static Future<bool>  saveLogged(bool ?isLogged)async{
    final pref= await SharedPreferences.getInstance();
    return pref.setBool("isLogged",isLogged!);
  }


  static Future<bool?> isLogged()async{
    final pref= await SharedPreferences.getInstance();
    return pref.getBool("isLogged");
  }
  // static Future<bool>  saveGuest(bool ?isGuest)async{
  //   final pref= await SharedPreferences.getInstance();
  //   return pref.setBool("isGuest",isGuest!);
  // }
  //
  //
  // static Future<bool?> isGuest()async{
  //   final pref= await SharedPreferences.getInstance();
  //   return pref.getBool("isGuest");
  // }

static Future<bool> setFavListId(List<int> favList)async{
  final pref= await SharedPreferences.getInstance();
  return pref.setStringList("favList", favList.map((e)=>e.toString()).toList());


}

  static Future<List<String>?> getFavListId()async{
    final pref= await SharedPreferences.getInstance();
    return pref.getStringList("favList");


  }

}