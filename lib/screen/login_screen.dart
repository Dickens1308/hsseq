// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsseq/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController =
      TextEditingController(text: "amsangi@springtech.co.tz");
  final _passwordController = TextEditingController(text: "admin");

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool _viewPassword = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, notifier, child) {
      return notifier.isLoading
          ? const Scaffold(
              body: Center(
                child: CupertinoActivityIndicator(
                  radius: 15,
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                elevation: 0,
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * .2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: const DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    'assets/images/logo.jpeg',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Sign in to Continue',
                              style:
                                  Theme.of(context).textTheme.headline6!.merge(
                                        const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Form(
                        key: globalKey,
                        child: Column(
                          children: [
                            _email(context),
                            _password(context),
                          ],
                        ),
                      ),
                    ),
                    _buttonField(notifier),
                  ],
                ),
              ),
            );
    });
  }

  Widget _password(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        obscureText: _viewPassword,
        controller: _passwordController,
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
            onPressed: () {
              setState(() {
                _viewPassword = !_viewPassword;
              });
            },
            icon: Icon(
              _viewPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(),
            gapPadding: 10,
          ),
        ),
      ),
    );
  }

  Widget _email(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        controller: _emailController,
        validator: (input) =>
            input!.isValidEmail() ? null : "check your email if is correct",
        decoration: InputDecoration(
          hintText: "Enter your email address",
          labelText: "Email",
          labelStyle: const TextStyle(
            fontSize: 24,
          ),
          prefixIcon: const Icon(
            Icons.mail,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(),
            gapPadding: 10,
          ),
        ),
      ),
    );
  }

  Widget _buttonField(notifier) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          if (globalKey.currentState!.validate()) {
            globalKey.currentState!.save();

            notifier.loginUser(
              _emailController.text,
              _passwordController.text,
              context,
            );
          }
        },
        child: AnimatedContainer(
            curve: Curves.easeInOutCubic,
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            decoration: BoxDecoration(
              color: Colors.blue[500],
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(milliseconds: 400),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .merge(const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
