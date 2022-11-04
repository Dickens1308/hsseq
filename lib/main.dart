import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hsseq/provider/auth_provider.dart';
import 'package:hsseq/provider/incident_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'app.dart';

void main() async {
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<IncidentProvider>(create: (_) => IncidentProvider())
      ],
      child: const MyApp(),
    ),
  );
}
