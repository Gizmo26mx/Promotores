import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/registro.dart';
import '../models/promotor.dart';

class DatabaseHelper {
  static const _databaseName = 'app_database.db';
  static const _databaseVersion = 2; // Incrementado por cambios en esquema

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, _databaseName),
      onCreate: _onCreate,
      version: _databaseVersion,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE registros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        detalle TEXT NOT NULL,
        sincronizado INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE promotores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        zona TEXT NOT NULL,
        sincronizado INTEGER DEFAULT 0,
        fecha_creacion TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE promotores (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          zona TEXT NOT NULL,
          sincronizado INTEGER DEFAULT 0,
          fecha_creacion TEXT NOT NULL
        )
      ''');
    }
  }

  // ==================== Operaciones para Registros ====================
  Future<int> insertRegistro(Registro registro) async {
    final db = await database;
    return await db.insert('registros', registro.toMap());
  }

  Future<List<Registro>> getRegistrosNoSincronizados() async {
    final db = await database;
    final maps = await db.query(
      'registros',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => Registro.fromMap(maps[i]));
  }

  Future<void> marcarRegistroSincronizado(int id) async {
    final db = await database;
    await db.update(
      'registros',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== Operaciones para Promotores ====================
  Future<int> insertPromotor(Promotor promotor) async {
    final db = await database;
    return await db.insert('promotores', promotor.toMap());
  }

  Future<List<Promotor>> getPromotores({String? filtroZona}) async {
    final db = await database;
    final maps = await db.query(
      'promotores',
      where: filtroZona != null && filtroZona != 'Todas'
          ? 'zona = ?'
          : null,
      whereArgs: filtroZona != null && filtroZona != 'Todas'
          ? [filtroZona]
          : null,
      orderBy: 'nombre ASC',
    );
    return maps.map((map) => Promotor.fromMap(map)).toList();
  }

  Future<List<Promotor>> getPromotoresNoSincronizados() async {
    final db = await database;
    final maps = await db.query(
      'promotores',
      where: 'sincronizado = ?',
      whereArgs: [0],
    );
    return maps.map((map) => Promotor.fromMap(map)).toList();
  }

  Future<void> marcarPromotorSincronizado(int id) async {
    final db = await database;
    await db.update(
      'promotores',
      {'sincronizado': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== Operaciones Generales ====================
  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('registros');
    await db.delete('promotores');
  }
}