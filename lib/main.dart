import 'package:flutter/material.dart';
import 'package:hsseq/provider/auth_provider.dart';
import 'package:hsseq/provider/incident_provider.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() async {
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();

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
