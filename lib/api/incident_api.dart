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
  Future<String?> createIncident(
      List<XFile> images,
      String? location,
      String desc,
      String? action,
      String? threat,
      String? accidentCategory) async {
    Uri url = Uri.parse("https://pft.springtech.co.tz/api/v1/incidents/create");
    http.StreamedResponse result;
    // String? msg;

    try {
      String? token = await getTokenPref();

      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = "Bearer $token";
      request.headers['accept'] = "application/json";

      request.fields['location'] = location!;
      request.fields['description'] = desc;
      request.fields['immediate_action_taken'] = action!;
      request.fields['threat'] = threat!;
      request.fields['accident_category'] = accidentCategory!;

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

  // Creating
  // Adding Photos to Incidence
  Future<String>? addMorePhotoToIncident(
      String? uuid, List<XFile> images) async {
    Uri url = Uri.parse("https://pft.springtech.co.tz/api/v1/incidents/images");
    http.StreamedResponse result;
    // String? msg;

    try {
      String? token = await getTokenPref();

      http.MultipartRequest request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = "Bearer $token";
      request.headers['accept'] = "application/json";

      request.fields['incident_id'] = uuid!;

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
        return "Incident images added";
      } else {
        throw Exception("Failed to add incident images!");
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

  // Fetch More Data For My Incident
  //Fetch My Incident
  Future<List<Incident>> fetchMoreMyIncident(int page) async {
    var url = Uri.parse(
        "https://pft.springtech.co.tz/api/v1/incidents/staff?page=$page");

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

  // Fetch More Data For My Incident
  //Fetch My Incident
  Future<List<Incident>> fetchMoreAllIncident(int page) async {
    var url = Uri.parse(
        "https://pft.springtech.co.tz/api/v1/incidents/all?page=$page");

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
  Future<Incident?> updateIncident(String? uuid, String? accidentCategory,
      String? location, String? desc, String? action, String? threat) async {
    http.Response result;

    var url = Uri.parse("https://pft.springtech.co.tz/api/v1/incidents/edit");

    try {
      String? token = await getTokenPref();

      result = await http.post(url, headers: {
        "accept": "application/json",
        "Authorization": "Bearer $token"
      }, body: {
        "id": uuid,
        "accident_category": accidentCategory,
        "location": location,
        "immediate_action_taken": action,
        "description": desc,
        "threat": threat
      });

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
      throw Exception("This is where error is $e");
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

  // Delete Incident Photo
  Future<String?> deleteIncedentPhoto(String? imageId) async {
    http.Response result;

    var url = Uri.parse(
        "https://pft.springtech.co.tz/api/v1/incidents/images/delete");

    try {
      String? token = await getTokenPref();

      result = await http.post(
        url,
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: {"id": imageId},
      );

      if (result.statusCode == 200) {
        return jsonDecode(result.body)["message"];
      } else {
        var msg = jsonDecode(result.body)["data"];
        throw Exception(msg);
      }
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> getTokenPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");

    return token;
  }
}
