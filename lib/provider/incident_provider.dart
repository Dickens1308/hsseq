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

class IncidentProvider extends ChangeNotifier {
  List<Incident> _incidentList = [];
  List<Incident> _myIncidentList = [];
  IncidentApi api = IncidentApi();
  bool _isLoading = false;
  bool _isDeleteLoading = false;
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
  bool get isDeleteLoading => _isDeleteLoading;

  void setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setIsDeleteLoading(bool loading) {
    _isDeleteLoading = loading;
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
  Future<List<Incident>?> fetchMyIncident(BuildContext context) async {
    try {
      setIsLoading(true);
      List<Incident> list = await api.fetchMyIncident();

      if (list.isNotEmpty) {
        setMyIncidentList(list);
        setIsLoading(false);
      }

      return list;
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

    return null;
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

  // Adding Photos to Incidence
  addMorePhotoToIncident(
      BuildContext context, String? uuid, List<XFile> photos) async {
    try {
      setIsLoading(true);
      bool isConnected = await _checkConnection();

      String? message =
          isConnected ? await api.addMorePhotoToIncident(uuid, photos) : null;

      if (message.toString() == "Incident images added") {
        fetchMyIncident(context).then((value) async {
          if (value != null) {
            Incident incident = _myIncidentList[
                _myIncidentList.indexWhere((e) => e.id == uuid)];

            Fluttertoast.showToast(
              msg: message.toString(),
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            );

            Navigator.of(context).pop(incident);
          }
        });
      }
    } catch (e) {
      log(e.toString());

      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
      );
    } finally {
      setIsLoading(false);
    }
  }

  // Delete Incident Photo
  Future<Incident?> deleteIncedentPhoto(
      BuildContext context, String? uuid, String? imageId) async {
    try {
      setIsDeleteLoading(true);
      bool isConnected = await _checkConnection();

      String? message =
          isConnected ? await api.deleteIncedentPhoto(imageId) : null;

      if (message == "Incident image removed") {
        Incident? incident = _deleteImageData(uuid, imageId);

        Fluttertoast.showToast(
          msg: "Incident photo was successful deleted!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );

        return incident;
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
      setIsDeleteLoading(false);
    }

    return null;
  }

  //Delete data in the list  after success delete
  // Notify Listener for the changes
  Incident? _deleteImageData(String? uuid, String? imageId) {
    try {
      // Searching for model in the list
      Incident temp =
          _myIncidentList[_myIncidentList.indexWhere((e) => e.id == uuid)];
      temp.images!.removeWhere((e) => e.id == imageId);

      notifyListeners();

      return temp;
    } catch (e) {
      log(e.toString());
      return null;
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
}
