// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hsseq/model/incident.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/action_form_field.dart';
import '../widgets/desc_form_field.dart';
import '../widgets/location_widget.dart';
import '../widgets/threat_form_widget.dart';

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
  late TextEditingController _threatController;

  //Risk Level Alerts
  String? _accidentCategory = 'PI/Hazard/Hatari';
  final _accidentCategoryList = [
    "PI/Hazard/Hatari",
    "Property Damage/Uharibifu wa mali/gari",
    "Near Miss/Kosa kosa/Almanusura",
    "Environmental Incident/Uharibifu wa mazingira",
    "Medical Treatment Injury/Ajari ya Kimatibabu",
    "Minor Injury (First Aid Injury)/Ajari ya huduma ya kwanza",
    "Lost Time Injury/Ajari ya kukosa kazini",
    "Fatality/Kifo",
  ];

  //Form State
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _accidentCategory = widget.incident.accidentCategory;
    _actionController =
        TextEditingController(text: widget.incident.immediateActionTaken);
    _locationController = TextEditingController(text: widget.incident.location);
    _descController = TextEditingController(text: widget.incident.description);
    _threatController = TextEditingController(text: widget.incident.threat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Incident")),
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
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Form(
                        key: _globalKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              _accidentCategoryWidget(context),
                              const SizedBox(height: 10),
                              LocationFormWidget(
                                  controller: _locationController),
                              const SizedBox(height: 10),
                              ThreatFormWidget(controller: _threatController),
                              const SizedBox(height: 10),
                              DescriptionFormWidget(
                                  controller: _actionController),
                              const SizedBox(height: 10),
                              ActionFormField(controller: _actionController),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    //Validate DropDown
                                    if (!_accidentCategoryList
                                        .contains(_accidentCategory)) {
                                      _toasterMessage(
                                          "Accident category field is required",
                                          Colors.red);
                                    }

                                    //Check Fields State and Send Post Request
                                    if (_globalKey.currentState!.validate()) {
                                      _globalKey.currentState!.save();

                                      Incident? incident1 =
                                          await notify.updateIncident(
                                              context,
                                              widget.incident.id,
                                              _accidentCategory,
                                              _locationController.text,
                                              _descController.text,
                                              _actionController.text,
                                              _threatController.text);

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

  Widget _accidentCategoryWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Accident Category/Aina ya Ajari',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
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
                'Select accident category',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              value: _accidentCategory,
              onChanged: (value) {
                setState(() {
                  _accidentCategory = value;
                });
              },
              items: _accidentCategoryList.map((list) {
                return DropdownMenuItem(
                  value: list,
                  child: Text(
                    list,
                    style: Theme.of(context).textTheme.bodyMedium,
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

//  Action Taken
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

  Widget _threatTextAreaField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 40,
        controller: _threatController,
        validator: (input) => input!.length < 2 ? "invalid threat" : null,
        decoration: InputDecoration(
          hintText: "Enter threat",
          labelText: "Threat",
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
