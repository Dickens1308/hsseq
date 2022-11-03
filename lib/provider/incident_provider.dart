import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hsseq/api/incident_api.dart';
import 'package:hsseq/model/incident.dart';

class IncidentProvider extends ChangeNotifier {
  List<Incident> _incidentList = [];
  IncidentApi api = IncidentApi();
  bool _isLoading = false;

  List<Incident> get incidentList => _incidentList;

  void setIncidentList(List<Incident> list) {
    _incidentList = list;
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
}
