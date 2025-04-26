import 'dart:io';
import 'package:flutter/services.dart'; // 👈 para leer el archivo de assets
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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

    // Verificar si el archivo de base de datos ya existe
    bool exists = await databaseExists(path);

    if (!exists) {
      // Si no existe, copiarlo desde assets
      try {
        ByteData data = await rootBundle.load('assets/database/promotores.db');
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
        print('Base de datos copiada desde assets');
      } catch (e) {
        print('Error copiando la base de datos: $e');
      }
    } else {
      print('Base de datos ya existe en el dispositivo');
    }

    // Abrir la base de datos
    return await openDatabase(path, version: _dbVersion);
  }

  // --- Métodos de acceso como ya tenías ---

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

  Future<int> insertUsuario(Map<String, dynamic> usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario);
  }

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

  Future<List<Promotor>> getAllPromotores() async {
    final db = await database;
    final maps = await db.query('promotores');
    return List.generate(maps.length, (i) => Promotor.fromMap(maps[i]));
  }

  Future<int> insertRegistro(Map<String, dynamic> registro) async {
    final db = await database;
    return await db.insert('registros', registro);
  }

  Future<List<Promotor>> getPromotores() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('promotores');
    return List.generate(maps.length, (i) {
      return Promotor.fromMap(maps[i]);
    });
  }
}
