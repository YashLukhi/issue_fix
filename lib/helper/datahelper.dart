import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, "quiz_app.db");

    return await openDatabase(path, version: 1, onCreate: (db, version) async {

      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          phone TEXT NOT NULL UNIQUE,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE quizzes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER,
          taskName TEXT,
          description TEXT,
          quizData TEXT,
          isCompleted INTEGER DEFAULT 0
        )
      ''');
    });
  }



  Future<int> registerUser(Map<String, dynamic> user) async {
    final db = await database;


    final existing = await db.query("users",
        where: "email = ? OR phone = ?",
        whereArgs: [user["email"], user["phone"]]);

    if (existing.isNotEmpty) {
      return -1;
    }

    return await db.insert("users", user);
  }


  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final res = await db.query("users",
        where: "email = ? AND password = ?", whereArgs: [email, password]);

    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query("users");
  }




  Future<int> insertQuiz(
      int userId, String taskName, String description, String quizData) async {
    final db = await database;
    return await db.insert("quizzes", {
      "userId": userId,
      "taskName": taskName,
      "description": description,
      "quizData": quizData,
      "isCompleted": 0
    });
  }


  Future<List<Map<String, dynamic>>> getUserQuizzes(int userId) async {
    final db = await database;
    return await db.query("quizzes", where: "userId = ?", whereArgs: [userId]);
  }


  Future<void> markQuizCompleted(int quizId) async {
    final db = await database;
    await db.update("quizzes", {"isCompleted": 1},
        where: "id = ?", whereArgs: [quizId]);
  }
}
