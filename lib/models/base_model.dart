import 'package:sqflite/sqflite.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path/path.dart';
import 'dart:async';

import 'package:clreader/constents.dart';
import 'package:clreader/book/book_info.dart';
import 'package:clreader/book/book_shelf.dart';
import 'package:clreader/book/book_src.dart';

class BaseModel extends Model {
  Database _database;

  Future<Database> get database async {
    return _database ?? await openDb();
  }

  Future<Database> openDb() async {
    String path = join(await getDatabasesPath(), Strings.databaseName);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table $tableBooks (
            $columnBookId integer primary key autoincrement,
            $columnBookName text not null,
            $columnBookAuthor text not null,
            $columnBookCoverUrl text not null,
            $columnBookIntroduction text not null,
            $cloumnBookSrc integer not null)
          ''');
      await db.execute('''
          create table $tableBookShelves (
            $columnBookShelfId integer primary key autoincrement,
            $columnBookShelfName text not null,
            $columnBookShelfBookIds text not null)
          ''');
      await db.execute('''
        create table $tableBookSrc (
          $columnBookSrcId text primary key,
          $columnBookSrcEnabled integer not null)
      ''');
    });
  }

  void closeDb() async {
    await _database.close();
  }
}
