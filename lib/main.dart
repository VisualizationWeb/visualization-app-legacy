import 'package:flutter/material.dart';
import 'package:visualization_app/views/home_view.dart';
import 'package:visualization_app/views/settings_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Step visualization app',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeView(),
        '/settings': (context) => SettingsView(),
      },
    );
  }
}
