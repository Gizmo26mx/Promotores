import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:promotores/models/promotor_model.dart';

class DatabaseHelper {
  static final _dbName = 'promotores.db';
  static final _dbVersion = 1;

  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

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

    // Si la base de datos ya existe en el almacenamiento local, la abrimos
    if (await File(path).exists()) {
      return await openDatabase(path);
    } else {
      // Si no existe, la copiamos desde los assets
      await _copyDatabase(path);
      return await openDatabase(path);
    }
  }

  Future<void> _copyDatabase(String path) async {
    // Cargar la base de datos desde los assets
    ByteData data = await rootBundle.load('assets/database/$_dbName');
    List<int> bytes = data.buffer.asUint8List();

    // Escribir el archivo de la base de datos en el almacenamiento local
    await File(path).writeAsBytes(bytes);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla usuarios
    await db.execute(''' 
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Tabla asociaciones
    await db.execute(''' 
      CREATE TABLE asociaciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero_asociacion TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        lider TEXT NOT NULL,
        telefono_lider TEXT NOT NULL,
        vestimenta TEXT NOT NULL
      )
    ''');

    // Tabla promotores
    await db.execute(''' 
      CREATE TABLE promotores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folio TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        apellidos TEXT NOT NULL,
        foto BLOB,
        numero_asociacion TEXT NOT NULL,
        sector TEXT,
        FOREIGN KEY (numero_asociacion) REFERENCES asociaciones (numero_asociacion)
      )
    ''');

    // Insertar usuario de prueba
    await db.insert('usuarios', {
      'username': 'admin',
      'password': '1234',
    });
  }

  // Métodos usuarios
  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario);
  }

  Future<int> updatePassword(String username, String newPassword) async {
    final db = await database;
    return await db.update(
      'usuarios',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  // Métodos asociaciones
  Future<int> insertAsociacion(Map<String, dynamic> asociacion) async {
    final db = await database;
    return await db.insert('asociaciones', asociacion);
  }

  Future<List<Map<String, dynamic>>> getAsociaciones() async {
    final db = await database;
    return await db.query('asociaciones');
  }

  // Métodos promotores
  Future<int> insertPromotor(Map<String, dynamic> promotor) async {
    final db = await database;
    return await db.insert('promotores', promotor);
  }

  Future<Promotor?> getPromotorByFolio(String folio) async {
    final db = await database;
    final result = await db.query(
      'promotores',
      where: 'folio = ?',
      whereArgs: [folio],
    );
    if (result.isNotEmpty) {
      return Promotor.fromMap(result.first);
    }
    return null;
  }

  Future<List<Promotor>> getAllPromotores() async {
    final db = await database;
    final result = await db.query('promotores');
    return result.map((e) => Promotor.fromMap(e)).toList();
  }

  Future<List<Promotor>> getPromotores() async {
    final db = await database;
    final result = await db.query('promotores');
    return result.map((e) => Promotor.fromMap(e)).toList();
  }

  Future<Map<String, dynamic>?> getAsociacionByNumero(String numeroAsociacion) async {
    final db = await database;
    final result = await db.query(
      'asociaciones',
      where: 'numero_asociacion = ?',
      whereArgs: [numeroAsociacion],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
