import 'package:flutter/material.dart';
import 'package:hsseq/screen/incident_page.dart';
import 'package:hsseq/screen/login_screen.dart';
import 'package:hsseq/screen/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      theme: ThemeData(
        fontFamily: 'Quicksand',
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case LoginScreen.routeName:
                return const LoginScreen();

              case IncidentPage.routeName:
                return const IncidentPage();

              default:
                return const SplashScreen();
            }
          },
        );
      },
    );
  }
}
