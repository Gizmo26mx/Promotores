import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('promotores.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE promotores (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            numero TEXT,
            nombre TEXT,
            empresa TEXT
          )
        ''');

        // Inserta un usuario y un promotor de prueba
        await db.insert('usuarios', {'username': 'admin', 'password': '1234'});
        await db.insert('promotores', {
          'numero': '001',
          'nombre': 'Juan Pérez',
          'empresa': 'Turismo Acapulco'
        });
      },
    );
  }

  Future<Map<String, dynamic>?> getPromotorByNumero(String numero) async {
    final db = await database;
    final res = await db.query('promotores', where: 'numero = ?', whereArgs: [numero]);
    if (res.isNotEmpty) return res.first;
    return null;
  }

  Future<bool> validateLogin(String username, String password) async {
    final db = await database;
    final res = await db.query('usuarios',
        where: 'username = ? AND password = ?', whereArgs: [username, password]);
    return res.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getPromotorByFolio(String folio) async {
    final db = await database;
    final res = await db.query(
      'promotores',
      where: 'folio = ?',
      whereArgs: [folio],
    );
    if (res.isNotEmpty) {
      return res.first;
    } else {
      return null;
    }
  }
}
