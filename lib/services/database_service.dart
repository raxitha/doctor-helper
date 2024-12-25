import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medical_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Create Users table
    await db.execute('''
      CREATE TABLE users (
        phone_number TEXT PRIMARY KEY
      )
    ''');

    // Create Prescriptions table
    await db.execute('''
      CREATE TABLE prescriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone_number TEXT,
        medicine_name TEXT,
        dosage TEXT,
        duration TEXT,
        date TEXT,
        FOREIGN KEY (phone_number) REFERENCES users (phone_number)
      )
    ''');
  }

  // User operations
  Future<bool> createUser(User user) async {
    final db = await instance.database;
    try {
      await db.insert('users', user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> getUser(String phoneNumber) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'phone_number = ?',
      whereArgs: [phoneNumber],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Prescription operations
  Future<bool> createPrescription(Prescription prescription) async {
    final db = await instance.database;
    try {
      await db.insert('prescriptions', prescription.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Prescription>> getUserPrescriptions(String phoneNumber) async {
    final db = await instance.database;
    final result = await db.query(
      'prescriptions',
      where: 'phone_number = ?',
      whereArgs: [phoneNumber],
    );

    return result.map((json) => Prescription.fromMap(json)).toList();
  }
}
