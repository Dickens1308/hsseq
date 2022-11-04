// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsseq/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  Future<User?> loginUser(String email, String password) async {
    http.Response result;

    var url = Uri.parse("https://pft.springtech.co.tz/api/v1/login");

    try {
      result =
          await http.post(url, body: {"email": email, "password": password});

      if (result.statusCode == 200) {
        Map<String, dynamic> json =
            Map<String, dynamic>.from(jsonDecode(result.body)["data"]["user"]);

        User user = User.fromJson(json);

        String token = jsonDecode(result.body)["data"]["token"];

        token.isNotEmpty ? saveTokenPref(token) : null;
        saveUserPref(user.id);

        return user;
      } else {
        String msg = jsonDecode(result.body)["message"];
        Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception(msg);
      }
    } catch (e) {
      // Fluttertoast.showToast(
      //   msg: e.toString(),
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
      log("AuthApi Error message is $e");
    }

    return null;
  }

  saveTokenPref(String? token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token!);
  }

  saveUserPref(String? guid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("guid", guid!);
  }
}
