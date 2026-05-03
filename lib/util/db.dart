import 'package:trabalho/models/model.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;

class DBUtil {
  static const String tableTarefas = 'Tarefas';

  static Future<sqlite.Database> _getDB() async {
    final databasePath = await sqlite.getDatabasesPath();
    final arqBD = path.join(databasePath, "tarefas_app.db");

    return sqlite.openDatabase(
      arqBD,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $tableTarefas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descricao TEXT NOT NULL,
            dataPrevista TEXT NOT NULL,
            importante INTEGER NOT NULL,
            realizada INTEGER NOT NULL,
            recompensa TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<void> insert(String table, Model model) async {
    final db = await _getDB();
    model.id = await db.insert(table, model.toMap());
  }

  static Future<List<Map<String, dynamic>>> list(String table) async {
    final db = await _getDB();
    return db.query(table);
  }

  static Future<int> delete(String table, int id) async {
    final db = await _getDB();
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> update(String table, Model model) async {
    final db = await _getDB();
    return await db.update(
      table,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}