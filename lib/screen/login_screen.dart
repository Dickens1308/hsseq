// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hsseq/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/email_field_widget.dart';
import '../widgets/password_field_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool viewPassword = true;

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
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Sign in to Continue',
                              style:
                                  Theme.of(context).textTheme.headline5!.merge(
                                        const TextStyle(
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
                            EmailFieldForm(controller: _emailController),
                            PasswordFieldForm(
                              controller: _passwordController,
                              viewPassword: viewPassword,
                              function: () {
                                setState(() {
                                  viewPassword = !viewPassword;
                                });
                              },
                            ),
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

  Widget _buttonField(notifier) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () {
            if (globalKey.currentState!.validate()) {
              globalKey.currentState!.save();

              notifier.loginUser(
                _emailController.text,
                _passwordController.text,
                context,
              );
            }
          },
          child: Text(
            'Sign in',
            style: Theme.of(context).textTheme.headline5!.merge(
                  const TextStyle(color: Colors.white),
                ),
          ),
        ),
      ),
    );
  }
}
