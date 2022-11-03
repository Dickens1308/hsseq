// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsseq/api/auth_api.dart';
import 'package:hsseq/model/User.dart';
import 'package:hsseq/screen/incident_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApi api = AuthApi();

  bool _isLoading = false;
  final bool _isLogged = false;
  late User _user;

  String _errorMessage = "";

  //Function to login user
  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    setIsLoading(true);

    api
        .loginUser(email, password)
        .then((value) => {
              if (value != null)
                {
                  setUser(value),
                  setIsLoading(false),
                  setIsLogged(true),
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      IncidentPage.routeName, (route) => false)
                }
              else
                {throw Exception("Failed to login")}
            })
        .catchError((onError) {
      setErrorMessage(onError.toString());
      // log("AuthProvider Error message is $onError");
      setIsLogged(false);
      setIsLoading(false);
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // ignore: invalid_return_type_for_catch_error
      return Future.value('');
    });
  }

  Future<String?> getTokenPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");

    return token;
  }

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  bool get isLogged => _isLogged;

  void setIsLogged(bool logged) {
    _isLoading = logged;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;

  void setErrorMessage(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }
}
