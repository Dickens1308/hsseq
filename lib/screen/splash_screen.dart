import 'package:flutter/material.dart';
import 'package:hsseq/screen/dashboard_screen.dart';
import 'package:hsseq/screen/login_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getTokenPref().then((value) => {
          if (value != null)
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, DashboardScreen.routeName, (route) => false),
            }
          else
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.routeName, (route) => false),
            }
        });
    super.initState();
  }

  Future<String?> getTokenPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");

    return token;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
