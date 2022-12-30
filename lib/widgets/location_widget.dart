import 'package:flutter/material.dart';

class LocationFormWidget extends StatelessWidget {
  const LocationFormWidget({Key? key, required this.controller})
      : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        keyboardType: TextInputType.text,
        controller: controller,
        validator: (input) => input!.length < 2 ? "invalid location" : null,
        decoration: InputDecoration(
          hintText: "Enter your location",
          labelText: "Location/Mahali",
          labelStyle: const TextStyle(
            fontSize: 14,
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
    ;
  }
}
