import 'package:flutter/material.dart';
import 'package:iot_temp_app/navigation/MainScreen.dart';
import 'package:iot_temp_app/themes/dark_theme.dart';
import 'package:iot_temp_app/themes/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const MainScreen());
  }
}
