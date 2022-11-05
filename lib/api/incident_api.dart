// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hsseq/model/incident.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncidentApi {
  //Create
  Future<String?> createIncident(List<XFile> images, String? risk,
      String? location, String desc, String? action) async {
    Uri url = Uri.parse("https://pft.springtech.co.tz/api/v1/incidents/create");
    http.StreamedResponse result;
    // String? msg;

    try {
      String? token = await getTokenPref();

      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = "Bearer $token";
      request.headers['accept'] = "application/json";

      request.fields['risk_level'] = risk!;
      request.fields['location'] = location!;
      request.fields['description'] = desc;
      request.fields['immediate_action_taken'] = action!;

      List<http.MultipartFile> list = <http.MultipartFile>[];

      for (int i = 0; i < images.length; i++) {
        list.add(
          http.MultipartFile(
            "photos[]",
            File(images[i].path).readAsBytes().asStream(),
            File(images[i].path).lengthSync(),
            filename: basename(images[i].path.split("/").last),
          ),
        );
      }

      request.files.addAll(list);
      result = await request.send();

      if (result.statusCode == 200) {
        return "Incident reported";
      } else {
        throw Exception("Incident failed to be reported, try again!");
      }
    } on SocketException catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  //Fetch My Incident
  Future<List<Incident>> fetchMyIncident() async {
    var url = Uri.parse("https://pft.springtech.co.tz/api/v1/incidents/staff");
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
  Future<Incident?> updateIncident(String? uuid, String? risk, String? location,
      String? desc, String? action) async {
    http.Response result;

    var url = Uri.parse("https://pft.springtech.co.tz/api/v1/incidents/edit");

    try {
      String? token = await getTokenPref();

      result = await http.post(
        url,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: {
          "id": uuid,
          "risk_level": risk,
          "location": location,
          "description": desc,
          "immediate_action_taken": action
        },
      );

      if (result.statusCode == 200) {
        Map<String, dynamic> json =
            Map<String, dynamic>.from(jsonDecode(result.body)["data"]);

        Incident incident = Incident.fromJson(json);

        return incident;
      } else {
        String msg = jsonDecode(result.body)["message"];

        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

//Add Incident Images
//Delete Incident
  Future<String?> deleteIncident(String? uuid) async {
    http.Response result;

    var url = Uri.parse("https://pft.springtech.co.tz/api/v1/incidents/delete");

    try {
      String? token = await getTokenPref();

      result = await http.post(
        url,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: {"id": uuid},
      );

      if (result.statusCode == 200) {
        return jsonDecode(result.body)["message"];
      } else {
        String msg = jsonDecode(result.body)["message"];

        throw Exception(msg);
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> getTokenPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");

    return token;
  }
}
