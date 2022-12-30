// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsseq/api/auth_api.dart';
import 'package:hsseq/db/role_db.dart';
import 'package:hsseq/db/user_db.dart';
import 'package:hsseq/model/user.dart';
import 'package:hsseq/screen/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApi api = AuthApi();
  final _userDb = UserDatabase.instance;
  final _roleDb = RoleDatabase.instance;

  bool _isLoading = false;
  final bool _isLogged = false;
  User _user = User();
  List<Roles> _roles = [Roles()];

  String _errorMessage = "";

  void checkUserOffline() {
    try {
      _userDb.fetchTransactions().then((value) => {setUser(value)});
      _roleDb
          .fetchTransactions()
          .then((value) => {setRoles(value)})
          .catchError((onError) {
        log(onError.toString());
      });
    } catch (e) {
      log(e.toString());
    }
  }

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
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      User? list = isConnected ? await api.loginUser(email, password) : null;
      log(list.toString());

      if (list != null) {
        setUser(list);
        setIsLogged(true);

        _userDb.insertData(list);

        for (var role in list.roles!) {
          _roleDb.insertData(role);
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamedAndRemoveUntil(
            DashboardScreen.routeName, (route) => false);
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
        gravity: ToastGravity.BOTTOM,
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

  List<Roles> get roles => _roles;

  void setRoles(List<Roles> value) {
    _roles = value;
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
        return false;
      }
    } else {
      return false;
    }
  }
}
