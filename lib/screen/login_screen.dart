import 'package:flutter/material.dart';
import 'package:hsseq/provider/auth_provider.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: "amsangi@springtech.co.tz");
  final TextEditingController _passwordController =
      TextEditingController(text: "admin");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Consumer<AuthProvider>(builder: (context, provider, child) {
        return provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'Company Title',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30),
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'Sign in to continue',
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (email) {
                              if (isEmailValid(email!)) {
                                return null;
                              } else {
                                return "Enter valid email address";
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            obscureText: obscure,
                            controller: _passwordController,
                            validator: (password) {
                              if (isPasswordValid(password!)) {
                                return null;
                              } else {
                                return "Password length must be greater than or equal 4";
                              }
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscure = !obscure;
                                  });
                                },
                                icon: const Icon(Icons.visibility),
                              ),
                              labelText: 'Password',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                            height: 50,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ElevatedButton(
                              child: const Text('Login'),
                              onPressed: () => provider.loginUser(
                                _emailController.text,
                                _passwordController.text,
                                context,
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('Does not have account?'),
                            TextButton(
                              child: const Text(
                                'Sign in',
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
                                //signup screen
                              },
                            )
                          ],
                        ),
                      ],
                    )),
              );
      }),
    );
  }

  //Validation email and password
  bool isPasswordValid(String password) => password.length >= 4;

  bool isEmailValid(String email) {
    bool pattern = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return pattern;
  }
}
