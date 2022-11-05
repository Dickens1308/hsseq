// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsseq/api/incident_api.dart';
import 'package:hsseq/model/incident.dart';
import 'package:hsseq/provider/auth_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncidentProvider extends ChangeNotifier {
  List<Incident> _incidentList = [];
  List<Incident> _myIncidentList = [];
  IncidentApi api = IncidentApi();
  bool _isLoading = false;
  final AuthProvider authProvider = AuthProvider();

  List<Incident> get incidentList => _incidentList;

  void setIncidentList(List<Incident> list) {
    _incidentList = list;
    notifyListeners();
  }

  List<Incident> get myIncidentList => _myIncidentList;

  void setMyIncidentList(List<Incident> list) {
    _myIncidentList = list;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  //Fetch All data
  void fetchAllIncident() {
    setIsLoading(true);
    api
        .fetchAllIncident()
        .then((value) => {
              if (value.isNotEmpty)
                {
                  setIncidentList(value),
                  setIsLoading(false),
                }
            })
        .catchError(
          // ignore: invalid_return_type_for_catch_error
          (onError) => {
            setIsLoading(false),
            log(onError.toString()),
          },
        );
  }

  //Fetch My Incident Only
  void fetchMyIncident(BuildContext context) async {
    try {
      setIsLoading(true);
      List<Incident> list = await api.fetchMyIncident();

      if (list.isNotEmpty) {
        setMyIncidentList(list);
        setIsLoading(false);
      }
    } catch (e) {
      setIsLoading(false);
      // Fluttertoast.showToast(
      //   msg: e.toString().replaceAll("Exception:", ""),
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
      log(e.toString());
    }
  }

  //Create Incident
  Future<bool> createIncident(BuildContext context, List<XFile> images,
      String? risk, String? location, String desc, String? action) async {
    try {
      setIsLoading(true);
      bool isConnected = await _checkConnection();
      String? message = isConnected
          ? await api.createIncident(images, risk, location, desc, action)
          : null;

      Fluttertoast.showToast(
          msg: message.toString(),
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.blue);

      if (message.toString() == "Incident reported") {
        log("Incident was reported");
        setIsLoading(false);

        return true;
      } else {
        setIsLoading(false);
        log("Incident was not reported");
        return false;
      }
    } catch (e) {
      log(e.toString());

      Fluttertoast.showToast(
        msg: e.toString().replaceAll("Exception: ", ""),
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
      );

      setIsLoading(false);

      return false;
    }
  }

  //Update Incident
  Future<Incident?> updateIncident(BuildContext context, String? uuid,
      String? risk, String? location, String desc, String? action) async {
    try {
      setIsLoading(true);
      bool isConnected = await _checkConnection();

      Incident? incident = isConnected
          ? await api.updateIncident(uuid, risk, location, desc, action)
          : null;

      if (incident != null) {
        incident = modifyMyIncident(incident);
        setIsLoading(false);

        return incident;
      } else {
        setIsLoading(false);

        Fluttertoast.showToast(
          msg: "Incident was not updated",
          toastLength: Toast.LENGTH_SHORT,
        );

        log("Incident was not updated");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
      );

      log(e.toString());
      setIsLoading(false);

      return null;
    }
  }

  // Delete Incident
  Future<void> deleteIncident(BuildContext context, String? uuid) async {
    try {
      setIsLoading(true);
      bool isConnected = await _checkConnection();

      String? message = isConnected ? await api.deleteIncident(uuid) : null;

      if (message == "Incident deleted") {
        _deleteData(uuid);

        Fluttertoast.showToast(
          msg: "Incident was successful deleted!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setIsLoading(false);
    }
  }

  //Delete data in the list  after success delete
  // Notify Listener for the changes
  void _deleteData(String? uuid) {
    try {
      // Searching for model in the list
      _myIncidentList.removeWhere((e) => e.id == uuid);
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  //Update data inside detail screen and list after success update
  // Notify Listener for the changes
  Incident? modifyMyIncident(Incident incident) {
    try {
      // Searching for model in the list
      Incident tempIncident = _myIncidentList[
          _myIncidentList.indexWhere((e) => e.id == incident.id)];

      tempIncident.location = incident.location;
      tempIncident.description = incident.description;
      tempIncident.immediateActionTaken = incident.immediateActionTaken;
      tempIncident.riskLevel = incident.riskLevel;
      tempIncident.updatedAt = incident.updatedAt;

      notifyListeners();

      return tempIncident;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Encountered an error while searching!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      return null;
    }
  }

  //Check if mobile phone has internet or not
  _checkConnection() async {
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

  Future<String?> _getUserPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? guid = preferences.getString("guid");

    return guid;
  }
}
