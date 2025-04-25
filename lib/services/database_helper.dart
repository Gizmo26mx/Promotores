import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/promotor_model.dart';
import '../models/asociacion_model.dart';
import '../models/usuario_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'promotores_acapulco.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE asociaciones (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        lider TEXT NOT NULL,
        telefono_lider TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE promotores (
        id TEXT PRIMARY KEY,
        folio TEXT UNIQUE NOT NULL,
        nombre TEXT NOT NULL,
        asociacion_id TEXT NOT NULL,
        sector TEXT NOT NULL,
        vestimenta TEXT NOT NULL,
        foto BLOB NOT NULL,
        FOREIGN KEY (asociacion_id) REFERENCES asociaciones(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE usuarios (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        rol TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE promotores ADD COLUMN sincronizado INTEGER DEFAULT 0');
    }
  }

  // Métodos CRUD para promotore
  Future<int> insertPromotor(Promotor promotor) async {
    final database = await db;
    return await database.insert(
      'promotores',
      promotor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Promotor?> getPromotorByFolio(String folio) async {
    final db = await database;
    final maps = await db.query(
      'promotores',
      where: 'folio = ?',
      whereArgs: [folio],
    );
    return maps.isNotEmpty ? Promotor.fromMap(maps.first) : null;
  }

// Métodos para asociaciones y usuarios...
  Future<int> getUserCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM usuarios')
    ) ?? 0;
  }
}