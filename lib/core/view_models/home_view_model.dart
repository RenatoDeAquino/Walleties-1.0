import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walleties/core/services/custom_api.dart';
import 'package:walleties/core/view_models/base_view_model.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel extends BaseViewModel {
  CustomAPI api = CustomAPI();
  static HomeViewModel homeViewModel;
  static HomeViewModel instance() {
    if (homeViewModel == null) {
      homeViewModel = HomeViewModel();
    }
    return homeViewModel;
  }

  Color blue = Color(0xFF63CBFF);
  Color lightGreen = Color(0xFF34AD89);
  Color darkGreen = Color(0xFF228464);
  Color lightBlue = Color(0xFFBCE9FF);

  bool getIsWeb() {
    return kIsWeb;
  }

  List<String> userInfo = List();

  void updateUserInfo(List<String> aux, int b) {
    b == 3
        ? userInfo = aux
        : b == 0
            ? userInfo[0] = aux[0]
            : b == 1
                ? userInfo[1] = aux[1]
                : b == 2 ? userInfo[2] = aux[2] : null;
    setUserInfo();
    notifyListeners();
  }

  Future<bool> setUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (userInfo.isEmpty) {
      return prefs.setStringList("userInfo", []) ?? false;
    } else {
      return prefs.setStringList("userInfo", userInfo) ?? false;
    }
  }

  Future<bool> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userInfo = [];

    if (prefs.getStringList("userInfo") == null) {
      userInfo = [];
      notifyListeners();
      return false;
    } else {
      List<String> userInfoaux = prefs.getStringList("userInfo");
      userInfo = userInfoaux;
      notifyListeners();
      return true;
    }
  }

  void flushbar(String message, int duration, BuildContext context) {
    Flushbar flush;
    flush = Flushbar(
      duration: Duration(seconds: 4),
      animationDuration: Duration(milliseconds: 500),
      borderRadius: 8,
      margin: EdgeInsets.all(8),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      icon: Icon(
        Icons.error_outline,
        color: Colors.white,
        size: 28,
      ),
      mainButton: FlatButton(
        onPressed: () => flush.dismiss(),
        child: Text(
          "Fechar",
          style: TextStyle(color: Colors.white),
        ),
      ),
    )..show(context);
  }

  bool showPasswordLogin = true;
  bool showPasswordSignUp = true;
  bool showConfirmPassword = true;
  void updateShowPassword(int aux) {
    aux == 0
        ? showPasswordLogin = !showPasswordLogin
        : aux == 1
            ? showPasswordSignUp = !showPasswordSignUp
            : showConfirmPassword = !showConfirmPassword;
    notifyListeners();
  }

  bool pressedGoogleLogin = false;
  void updatePressedGoogleLogin(bool aux) {
    pressedGoogleLogin = aux;
    notifyListeners();
  }

  bool isTextFieldChanging = false;
  void updateIsTextFieldChanging(bool aux) {
    isTextFieldChanging = aux;
    notifyListeners();
  }

  bool showLoginButton;
  void updateShowLoginButton(bool aux) {
    showLoginButton = aux;
    notifyListeners();
  }

  HomeViewModel() {
    isTextFieldChanging = false;
    showLoginButton = false;
    getUserInfo();
  }
}
