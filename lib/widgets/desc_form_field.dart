import 'package:flutter/material.dart';

class DescriptionFormWidget extends StatelessWidget {
  const DescriptionFormWidget({Key? key, required this.controller})
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
}
