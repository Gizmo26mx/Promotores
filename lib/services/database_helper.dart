import 'dart:io';
//import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
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
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Crear tabla usuarios
    await db.execute(''' 
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Crear tabla asociaciones
    await db.execute(''' 
      CREATE TABLE asociaciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL
      )
    ''');

    // Crear tabla promotores
    await db.execute(''' 
      CREATE TABLE promotores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folio TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        asociacion_id INTEGER,
        sector TEXT,
        vestimenta TEXT,
        foto BLOB,
        activo INTEGER NOT NULL DEFAULT 1,
        fecha_registro TEXT,
        FOREIGN KEY (asociacion_id) REFERENCES asociaciones(id)
      )
    ''');

    // Crear tabla registros
    await db.execute(''' 
      CREATE TABLE registros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        promotor_id INTEGER NOT NULL,
        fecha TEXT NOT NULL,
        observaciones TEXT,
        FOREIGN KEY (promotor_id) REFERENCES promotores(id)
      )
    ''');

    // Insertar usuario de prueba
    await db.insert('usuarios', {
      'username': 'admin',
      'password': '1234',
    });
  }

  // Metodo de autenticación: obtener usuario
  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    final db = await database;
    final result = await db.query(
      'usuarios',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
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

  // Metodo para insertar un nuevo usuario
  Future<int> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario);
  }

  // Metodo para obtener promotor por folio
  Future<Promotor?> getPromotorByFolio(String folio) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'promotores',
      where: 'folio = ?',
      whereArgs: [folio],
    );
    if (result.isNotEmpty) {
      return Promotor.fromMap(result.first);
    }
    return null;
  }

  // Metodo para obtener todos los promotores
  Future<List<Promotor>> getAllPromotores() async {
    final db = await database;
    final maps = await db.query('promotores');
    return List.generate(maps.length, (i) => Promotor.fromMap(maps[i]));
  }

  // Metodo para insertar un registro
  Future<int> insertRegistro(Map<String, dynamic> registro) async {
    final db = await database;
    return await db.insert('registros', registro);
  }

  // Metodo para obtener todos los promotores (sin parámetros)
  Future<List<Promotor>> getPromotores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('promotores');
    return List.generate(maps.length, (i) {
      return Promotor.fromMap(maps[i]);
    });
  }
}
