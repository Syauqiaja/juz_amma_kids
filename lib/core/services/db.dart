import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuranicDatabase {
  static final QuranicDatabase instance = QuranicDatabase._internal();
  static Database? _database;

  QuranicDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = '${documentsDirectory.path}/quran-db.db';
    print(path);
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load('assets/quran-db.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      var db = await openDatabase(
        path,
      );
      await db.execute('''
        ALTER TABLE "quran_words"
        RENAME TO "quran"
      ''');
      await db.execute('''
        CREATE TABLE read_tracks(
          id INTEGER PRIMARY KEY,
          user_id INT NOT NULL,
          lesson INT NOT NULL,
          year INT NOT NULL,
          sora INT NOT NULL,
          memorized TEXT DEFAULT '{}',
          read TEXT DEFAULT '{}'
        )
      ''');
      await db.execute('''
        CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            username TEXT NOT NULL,
            name TEXT NOT NULL,
            role TEXT,
            photo_url TEXT,
            updated_at TEXT NOT NULL
        )
      ''');
      return db;
    }

    return openDatabase(path, version: 12);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
