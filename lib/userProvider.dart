import 'package:campus_connect/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'db.dart';

class UserProvider extends ChangeNotifier {
  bool isAdmin = false;

  UserProvider() {
    if (supabase.auth.currentUser != null) {
      init();
    }
  }

  void init() async {
    Map? userInfo = await getUserInfo();
    if (userInfo != null) {
      isAdmin = userInfo["isAdmin"];
    }
    notifyListeners();
  }

  Future signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final result = await supabase.auth
          .signInWithPassword(email: email, password: password);
      if (result.user != null) {
        Map? userInfo = await getUserInfo();
        if (userInfo != null) {
          isAdmin = userInfo["isAdmin"];
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> signUp({
    required String englishName,
    required String chineseName,
    required String email,
    required String password,
    required int studentNumber,
    required BuildContext context,
  }) async {
    try {
      AuthResponse auth = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (auth.user != null) {
        //create the map of user info
        Map<String, dynamic> userInfo = {
          "username": englishName,
          "chineseName": chineseName,
          "email": email,
          "starred": [],
          "CsHours": 0,
          "isAdmin": false,
          "completed": [],
          "studentNumber": studentNumber,
        };
        isAdmin = false;
        notifyListeners();
        setUserInfo(userInfo);
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future signOut() async {
    await supabase.auth.signOut();
    isAdmin = false;
    notifyListeners();
  }
}
