// ============================
// database_helper.dart (Updated)
// ============================
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/question.dart';
import '../model/user.dart';
import '../model/question_image.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'feqiz.db');

    bool databaseExists = await File(path).exists();
    if (!databaseExists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load(join("assets", "database", "fequiz.db"));
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        rethrow;
      }
    }
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT,
        userImage BLOB
      )
      '''
    );
  }

  // --- CRUD Operations for Users ---
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // --- CRUD Operations for Questions ---
  Future<List<Question>> getQuestions(String year, String month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
          q.id,
          q.sub_question,
          q.answer_a,
          q.answer_b,
          q.answer_c,
          q.answer_d,
          q.correct_answer
      FROM
          questions AS q
      JOIN
          year AS y ON q.year_id = y.id
      WHERE
          y.year = ? AND y.month = ?
    ''', [year, month]);

    return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
  }

  // --- CRUD Operations for QuestionImage ---
  Future<int> insertQuestionImage(QuestionImage image) async {
    final db = await database;
    return await db.insert('question_image', image.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<QuestionImage>> getAllQuestionImages() async {
    print("databaseQuestionImage");
    final db = await database;
    final result = await db.query('question_image');
    print("result$result");
    return result.map((map) => QuestionImage.fromMap(map)).toList();
  }

  Future<QuestionImage?> getQuestionImageByQuestionId(int questionId) async {
    final db = await database;
    final result = await db.query(
      'question_image',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
    if (result.isNotEmpty) {
      return QuestionImage.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateQuestionImage(QuestionImage image) async {
    final db = await database;
    return await db.update(
      'question_image',
      image.toMap(),
      where: 'id = ?',
      whereArgs: [image.id],
    );
  }

  Future<int> deleteQuestionImage(int id) async {
    final db = await database;
    return await db.delete(
      'question_image',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
