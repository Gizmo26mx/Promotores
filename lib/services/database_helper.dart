import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _dbName = 'promotores.db';
  static final _dbVersion = 1;
  static final _tableName = 'usuarios';
  static final _promotoresTable = 'promotores';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> initDB() async {
    await database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_promotoresTable (
        id INTEGER PRIMARY KEY,
        nombre TEXT NOT NULL,
        numero_promotor TEXT NOT NULL UNIQUE,
        empresa TEXT
      )
    ''');

    // Usuario y promotor de prueba
    await db.insert(_tableName, {
      'username': 'admin',
      'password': '1234'
    });
    await db.insert(_promotoresTable, {
      'nombre': 'Juan Pérez',
      'numero_promotor': 'PR1234',
      'empresa': 'Turismo Acapulco'
    });
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<Map<String, dynamic>?> getPromotorByNumero(String numero) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      _promotoresTable,
      where: 'numero_promotor = ?',
      whereArgs: [numero],
    );
    if (result.isNotEmpty) return result.first;
    return null;
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