// ignore_for_file: depend_on_referenced_packages

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
      String? guid = await _getUserPref();
      List<Incident> list = await api.fetchMyIncident(guid);

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
        toastLength: Toast.LENGTH_SHORT,
      );

      if (message.toString() == "Incident reported") {
        log("Incident was reported");
        return true;
      } else {
        setIsLoading(false);
        log("Incident was not reported");
        return false;
      }
    } catch (e) {
      log(e.toString());
      setIsLoading(false);

      return false;
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
