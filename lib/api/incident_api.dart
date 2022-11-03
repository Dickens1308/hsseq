import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hsseq/model/incident.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class IncidentApi {
  //Create
  //Fetch Incident
  //Fetch All Incident
  Future<List<Incident>> fetchAllIncident() async {
    var url = Uri.parse("https://pft.springtech.co.tz/api/v1/incidents/all");
    http.Response result;
    List<Incident> list = [];

    try {
      String? token = await getTokenPref();
      result = await http.get(
        url,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (result.statusCode == 200) {
        var decodeMsg = jsonDecode(result.body)["data"]["data"];

        var temp =
            (decodeMsg as List).map((data) => Incident.fromJson(data)).toList();
        list = temp;
      } else {
        String msg = jsonDecode(result.body)["message"];
        throw Exception(msg);
      }
    } on SocketException catch (e) {
      log("Error occurred $e");
    }

    return list;
  }

//Staff Incident
//Edit Incident
//Add Incident Images
//Delete Incident

  Future<String?> getTokenPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");

    return token;
  }
}
