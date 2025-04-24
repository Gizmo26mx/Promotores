import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promotores/screens/login_screen.dart';
import 'package:promotores/screens/registros_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class AuthProvider extends ChangeNotifier {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Stream<User?> get authStateChanges => FirebaseAuth.instance.authStateChanges();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Mi App')),
        body: const Center(child: Text('¡Firebase inicializado!')),
      ),
    );
  }
}