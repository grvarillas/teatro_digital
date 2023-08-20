import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'play_script.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS plays (
            id INTEGER PRIMARY KEY,
            title TEXT,
            playwright TEXT
          )
        ''');
        // Add more CREATE TABLE statements for other elements
      },
    );
  }

  Future<void> insertPlay(String title, String author) async {
    final db = await database;
    await db.insert('PLAYS', {'title': title, 'BY: ':author});
  }

  Future<List<Map<String, dynamic>>> getAllPlays() async {
    final db = await database;
    return db.query('plays');
  }

  // Add more methods for other elements like characters, acts, scenes, etc.
}
