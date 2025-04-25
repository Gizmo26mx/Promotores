import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class DatabaseHelper {
  static const _databaseName = 'promotores_acapulco.db';
  static const _databaseVersion = 1;

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  // Configuración de claves foráneas
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // CREACIÓN DE TABLAS (Aquí se implementan las tablas)
  Future<void> _onCreate(Database db, int version) async {
    // 1. Tabla de Usuarios (para login)
    await db.execute('''
      CREATE TABLE usuarios (
        id TEXT PRIMARY KEY,
        username TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        rol TEXT NOT NULL CHECK (rol IN ('admin', 'validador')),
        fecha_creacion TEXT DEFAULT (datetime('now','localtime'))
      )
    ''');

    // 2. Tabla de Asociaciones
    await db.execute('''
      CREATE TABLE asociaciones (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        lider TEXT NOT NULL,
        telefono_lider TEXT NOT NULL,
        descripcion TEXT,
        logo BLOB,
        fecha_registro TEXT DEFAULT (datetime('now','localtime'))
      )
    ''');

    // 3. Tabla de Promotores (con relación a asociaciones)
    await db.execute('''
      CREATE TABLE promotores (
        folio TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        asociacion_id TEXT NOT NULL,
        sector TEXT NOT NULL,
        vestimenta TEXT NOT NULL,
        foto BLOB NOT NULL,
        activo INTEGER DEFAULT 1,
        fecha_registro TEXT DEFAULT (datetime('now','localtime')),
        FOREIGN KEY (asociacion_id) REFERENCES asociaciones(id) ON DELETE RESTRICT
      )
    ''');

    // Índices para mejorar el rendimiento
    await db.execute('''
      CREATE INDEX idx_promotor_asociacion 
      ON promotores(asociacion_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_promotor_activo 
      ON promotores(activo) WHERE activo = 1
    ''');
  }

// Métodos CRUD para cada tabla...
// [Aquí irían los métodos para insertar/actualizar/consultar datos]
}