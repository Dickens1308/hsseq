import 'package:flutter/material.dart';

class PasswordFieldForm extends StatelessWidget {
  const PasswordFieldForm(
      {Key? key,
      required this.controller,
      required this.viewPassword,
      required this.function})
      : super(key: key);
  final TextEditingController controller;
  final bool viewPassword;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: viewPassword,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) => input!.length < 4
            ? "Password length should have more than 4 characters"
            : null,
        decoration: InputDecoration(
          hintText: "Enter your password",
          labelText: "Password",
          labelStyle: const TextStyle(
            fontSize: 24,
          ),
          prefixIcon: const Icon(
            Icons.lock,
          ),
          suffixIcon: IconButton(
            onPressed: () => function(),
            icon: Icon(
              viewPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(),
            gapPadding: 10,
          ),
        ),
      ),
    );
  }
}
