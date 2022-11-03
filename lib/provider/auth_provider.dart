// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
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

    try {
      bool isConnected = await checkConnection();
      if (!isConnected) {
        Fluttertoast.showToast(
          msg: "Check you internet connection!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      log(isConnected.toString());
      User? list = isConnected ? await api.loginUser(email, password) : null;
      log(list.toString());

      if (list != null) {
        setUser(list);
        setIsLogged(true);
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushNamedAndRemoveUntil(IncidentPage.routeName, (route) => false);
      }

      setIsLoading(false);
    } catch (e) {
      setErrorMessage(e.toString());
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
    }
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

  //Check if mobile phone has internet or not
  checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('pft.springtech.co.tz');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } on SocketException catch (_) {
        Fluttertoast.showToast(msg: "This is socket toast");
        return false;
      }
    } else {
      return false;
    }
  }
}
