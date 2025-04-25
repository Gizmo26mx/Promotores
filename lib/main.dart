import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:promotores/screens/login_screen.dart';
import 'package:promotores/screens/registros_screen.dart'; //
import 'package:promotores/services/database_helper.dart';
import 'package:promotores/models/usuario_model.dart';

void main() async {
  // Asegurar que los widgets de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar la base de datos SQLite
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.initializeDatabase();

  // Cargar datos iniciales si es necesario
  await _initializeApp(dbHelper);

  // Ejecutar la aplicación
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(dbHelper),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _initializeApp(DatabaseHelper dbHelper) async {
  // Verificar si ya existen usuarios para evitar duplicados
  final userCount = await dbHelper.getUserCount();

  if (userCount == 0) {
    await _insertInitialData(dbHelper);
  }
}

Future<void> _insertInitialData(DatabaseHelper dbHelper) async {
  // Insertar usuario administrador por defecto
  const defaultAdmin = Usuario(
    id: 'admin1',
    username: 'admin',
    passwordHash: 'd82494f05d6917ba02f7aaa29689ccb444bb73f20380876cb05d1f37537b7892', // hash de 'admin123'
    rol: 'admin',
    fechaCreacion: '2023-01-01',
  );

  await dbHelper.insertUsuario(defaultAdmin);

  // Aquí puedes agregar más datos iniciales si es necesario
  // await _insertInitialPromotores(dbHelper);
  // await _insertInitialAsociaciones(dbHelper);
}

class AuthProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper;
  Usuario? _currentUser;

  AuthProvider(this._dbHelper);

  Usuario? get currentUser => _currentUser;

  Future<bool> login(String username, String password) async {
    try {
      final user = await _dbHelper.getUsuarioByUsername(username);

      if (user != null && _verifyPassword(password, user.passwordHash)) {
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

  bool _verifyPassword(String inputPassword, String storedHash) {
    // En una app real, usaría un algoritmo de hashing seguro como bcrypt
    // Esta es una implementación básica para demostración
    return _hashPassword(inputPassword) == storedHash;
  }

  String _hashPassword(String password) {
    // Implementación básica - en producción usaría package:crypto
    return password; // Reemplazar con hashing real
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
      theme: _buildAppTheme(),
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          return auth.currentUser != null
              ? const RegistrosScreen()
              : const LoginScreen();
        },
      ),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}