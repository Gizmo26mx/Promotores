import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'db/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Promotores Acapulco',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}