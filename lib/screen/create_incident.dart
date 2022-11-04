// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CreateIncident extends StatefulWidget {
  const CreateIncident({Key? key}) : super(key: key);

  static const routeName = "create_incident";

  @override
  State<CreateIncident> createState() => _CreateIncidentState();
}

class _CreateIncidentState extends State<CreateIncident> {
  final _actionController = TextEditingController(text: "Please check before sunday this incident");
  final _locationController = TextEditingController(text: "Mbezi");
  final _descController = TextEditingController(text: "This is description body for application");

  //Risk Level Alerts
  String? _risk;
  final _riskArray = ['High', 'Medium', 'Low'];

  //Form State
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Image Upload Variables & Methods
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFiles;

  openImageGallery() async {
    try {
      var isPermissionAllowed = await _checkPermission();
      var pickedFiles =
          isPermissionAllowed ? await imagePicker.pickMultiImage() : null;
      if (pickedFiles != null) {
        _toasterMessage("${pickedFiles.length} image(s) selected", Colors.blue);
        log("Total image(s) selected: ${pickedFiles.length}");

        imageFiles = pickedFiles;
        setState(() {});
      } else {
        _toasterMessage("No image file selected", Colors.blue);
        log("No image is selected.");
      }
    } catch (e) {
      log(e.toString());
    }
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
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: () => openImageGallery(),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text("Upload Images"),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //Validate DropDown
                                    if (imageFiles == null &&
                                        !_riskArray.contains(_risk)) {
                                      _toasterMessage(
                                          "Risk level & Images fields are required",
                                          Colors.red);
                                    } else if (imageFiles != null &&
                                        !_riskArray.contains(_risk)) {
                                      _toasterMessage(
                                          "Risk level field is required",
                                          Colors.red);
                                    } else if (imageFiles != null &&
                                        !_riskArray.contains(_risk)) {
                                      _toasterMessage(
                                          "Please Image is required",
                                          Colors.red);
                                    }

                                    //Check Fields State and Send Post Request
                                    if (_globalKey.currentState!.validate()) {
                                      _globalKey.currentState!.save();

                                      bool isCompleted =
                                          await notify.createIncident(
                                              context,
                                              imageFiles!,
                                              _risk,
                                              _locationController.text,
                                              _descController.text,
                                              _actionController.text);

                                      if (isCompleted) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop(true);
                                      }
                                    }

                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Text("Save Incident"),
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

  Future<bool> _checkPermission() async {
    Map<Permission, PermissionStatus> status =
        await [Permission.storage].request();

    if (status[Permission.storage]!.isGranted) {
      return true;
    } else {
      _toasterMessage("Permission Denied!", Colors.red);
      return false;
    }
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
