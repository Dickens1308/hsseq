import 'package:flutter/material.dart';

import 'screen/all_incident.dart';
import 'screen/create_incident.dart';
import 'screen/dashboard_screen.dart';
import 'screen/login_screen.dart';
import 'screen/my_incident_screen.dart';
import 'screen/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.blue,
          // backgroundColor: Color(0xffefeeef),
        ),
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: const Color(0xffefeeef),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case LoginScreen.routeName:
                return const LoginScreen();

              case DashboardScreen.routeName:
                return const DashboardScreen();

              case AllIncident.routeName:
                return const AllIncident();

              case MyIncidentScreen.routeName:
                return const MyIncidentScreen();

              case CreateIncident.routeName:
                return const CreateIncident();

              default:
                return const SplashScreen();
            }
          },
        );
      },
    );
  }
}
