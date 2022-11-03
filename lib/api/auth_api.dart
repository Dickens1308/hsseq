import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hsseq/model/User.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  Future<User?> loginUser(String email, String password) async {
    http.Response result;

    var url = Uri.parse("https://pft.springtech.co.tz/api/v1/login");

    try {
      result = await http.post(url,
          headers: {"accept": "application/json"},
          body: {"email": email, "password": password});

      if (result.statusCode == 200) {
        Map<String, dynamic> json =
            Map<String, dynamic>.from(jsonDecode(result.body)["data"]["user"]);

        User user = User.fromJson(json);

        String token = jsonDecode(result.body)["data"]["token"];

        token.isNotEmpty ? saveTokenPref(token) : null;

        return user;
      } else {
        String msg = jsonDecode(result.body)["message"];
        throw Exception(msg);
      }
    } on SocketException catch (e) {
      log("AuthApi Error message is $e");
    }

    return null;
  }

  saveTokenPref(String? token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token!);
  }
}
