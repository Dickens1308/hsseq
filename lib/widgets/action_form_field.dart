import 'package:flutter/material.dart';

class ActionFormField extends StatelessWidget {
  const ActionFormField({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 3,
        maxLines: 40,
        controller: controller,
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
}
