import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:promotores/screens/login_screen.dart';
import 'package:promotores/services/database_helper.dart';
import 'package:promotores/models/usuario_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar SQLite primero
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.initializeDatabase();

  // Opcional: mantener Firebase para futura sincronización
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

Future<void> _initializeApp(DatabaseHelper dbHelper) async {
  // Verificar si ya existen datos para no duplicarlos
  final count = await dbHelper.database.then((db) =>
      Sqflite.firstIntValue(db.rawQuery('SELECT COUNT(*) FROM usuarios')));

  if (count == 0) {
    await _insertarDatosIniciales(dbHelper);
  }
}

Future<void> _insertarDatosIniciales(DatabaseHelper dbHelper) async {
  // Insertar usuario administrador
  final admin = Usuario(
    id: 'admin1',
    username: 'admin',
    passwordHash: _hashPassword('admin123'), // Función de hashing
    rol: 'admin',
    fechaCreacion: DateTime.now().toIso8601String(),
  );

  await dbHelper.insertUsuario(admin);

  // Insertar datos de prueba (asociaciones y promotores)
  // ... (agrega aquí la lógica para insertar tus datos iniciales)
}

String _hashPassword(String plainText) {
  // En una aplicación real, usa un paquete como flutter_secure_storage
  // Esto es solo para demostración
  return plainText;
}

class AuthProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper;
  Usuario? _currentUser;

  AuthProvider(this._dbHelper);

  Usuario? get currentUser => _currentUser;

  Future<bool> login(String username, String password) async {
    try {
      final user = await _dbHelper.getUsuarioByUsername(username);

      if (user != null && user.passwordHash == _hashPassword(password)) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error en login: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Validación de Promotores Acapulco',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.currentUser != null) {
            return const RegistrosScreen(); // Pantalla después de login
          } else {
            return const LoginScreen(); // Pantalla de login
          }
        },
      ),
    );
  }
}