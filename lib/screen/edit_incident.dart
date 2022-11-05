// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hsseq/model/incident.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:provider/provider.dart';

class EditIncident extends StatefulWidget {
  const EditIncident({Key? key, required this.incident}) : super(key: key);

  final Incident incident;

  @override
  State<EditIncident> createState() => _EditIncidentState();
}

class _EditIncidentState extends State<EditIncident> {
  late TextEditingController _actionController;
  late TextEditingController _locationController;
  late TextEditingController _descController;

  //Risk Level Alerts
  String? _risk;
  final _riskArray = ['High', 'Medium', 'Low'];

  //Form State
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _risk = widget.incident.riskLevel;
    _actionController =
        TextEditingController(text: widget.incident.immediateActionTaken);
    _locationController = TextEditingController(text: widget.incident.location);
    _descController = TextEditingController(text: widget.incident.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Incident")),
      body: Consumer<IncidentProvider>(
        builder: (context, notify, child) {
          return notify.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.dark,
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Form(
                        key: _globalKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Fill in the form below to create incidence',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .merge(
                                      const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                              const SizedBox(height: 30),
                              _riskLevelDropDown(context),
                              const SizedBox(height: 10),
                              _locationField(context),
                              const SizedBox(height: 10),
                              _descriptionField(context),
                              const SizedBox(height: 10),
                              _actionTakenField(context),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //Validate DropDown
                                    if (!_riskArray.contains(_risk)) {
                                      _toasterMessage(
                                          "Risk level field is required",
                                          Colors.red);
                                    }

                                    //Check Fields State and Send Post Request
                                    if (_globalKey.currentState!.validate()) {
                                      _globalKey.currentState!.save();

                                      Incident? incident1 =
                                          await notify.updateIncident(
                                        context,
                                        widget.incident.id,
                                        _risk,
                                        _locationController.text,
                                        _descController.text,
                                        _actionController.text,
                                      );

                                      if (incident1 != null) {
                                        Navigator.of(context).pop(incident1);
                                      }
                                    }
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text("Save Changes"),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _riskLevelDropDown(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Risk Level',
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 8),
        Container(
          height: 60,
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey,
              )),
          child: Center(
            child: DropdownButton(
              isExpanded: true,
              underline: const SizedBox(),
              elevation: 0,
              hint: const Text(
                'Select Risk Level',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: _risk,
              onChanged: (value) {
                setState(() {
                  _risk = value;
                });
              },
              items: _riskArray.map((list) {
                return DropdownMenuItem(
                  value: list,
                  child: Text(
                    list,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

//  Location
  Widget _locationField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: _locationController,
        validator: (input) => input!.length < 2 ? "invalid location" : null,
        decoration: InputDecoration(
          hintText: "Enter your location",
          labelText: "Location",
          labelStyle: const TextStyle(
            fontSize: 24,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(),
            gapPadding: 10,
          ),
        ),
      ),
    );
  }

//  Description
  Widget _descriptionField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 40,
        controller: _descController,
        validator: (input) => input!.length < 2 ? "invalid description" : null,
        decoration: InputDecoration(
          hintText: "Enter description",
          labelText: "Description",
          labelStyle: const TextStyle(
            fontSize: 24,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(),
            gapPadding: 10,
          ),
        ),
      ),
    );
  }

//  Description
  Widget _actionTakenField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 3,
        maxLines: 40,
        controller: _actionController,
        validator: (input) => input!.length < 2 ? "invalid action taken" : null,
        decoration: InputDecoration(
          hintText: "Enter immediate action taken",
          labelText: "Immediate Action Taken",
          labelStyle: const TextStyle(
            fontSize: 24,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(),
            gapPadding: 10,
          ),
        ),
      ),
    );
  }

  void _toasterMessage(String msg, Color colors) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: colors,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
