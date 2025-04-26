import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:promotores/models/promotor_model.dart';
import 'package:promotores/models/asociacion_model.dart';
import 'package:promotores/models/usuario_model.dart';


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
    CREATE TABLE $_promotoresTable (
      folio TEXT PRIMARY KEY,
      nombre TEXT NOT NULL,
      asociacion TEXT NOT NULL,
      sector TEXT NOT NULL,
      lider TEXT NOT NULL,
      telefono_lider TEXT NOT NULL,
      vestimenta TEXT NOT NULL,
      foto BLOB NOT NULL
    )
  ''');

    // Datos de prueba (opcional)
    await db.insert(_promotoresTable, {
      'folio': 'FOLIO001',
      'nombre': 'Juan Pérez',
      'asociacion': 'Asociación Turística',
      'sector': 'Zona Dorada',
      'lider': 'María Gómez',
      'telefono_lider': '7441234567',
      'vestimenta': 'Camisa blanca',
      'foto': Uint8List(0) // Foto vacía para prueba
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

  Future<Promotor?> getPromotorByFolio(String folio) async {
    final db = await database;
    final maps = await db.query(
      _promotoresTable,
      where: 'folio = ?',
      whereArgs: [folio],
    );

    if (maps.isNotEmpty) {
      return Promotor.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Promotor>> getAllPromotores() async {
    final db = await database;
    final maps = await db.query('promotores');
    return List.generate(maps.length, (i) => Promotor.fromMap(maps[i]));
  }


}