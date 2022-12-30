import 'package:flutter/material.dart';

class ThreatFormWidget extends StatelessWidget {
  const ThreatFormWidget({Key? key, required this.controller})
      : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 5,
        maxLines: 40,
        controller: controller,
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
}
