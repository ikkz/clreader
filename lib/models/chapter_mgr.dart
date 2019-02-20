import 'dart:async';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/book/book_info.dart';
import 'package:clreader/book/chapter.dart';

class ChapterMgr extends BaseModel {
  Future<void> createChapters(BookInfo bookInfo) async {
    final db = await database;
    await db.execute('''
        create table if not exists ${tableName(bookInfo)} (
          $columnChapterId integer primary key autoincrement,
          $columnChapterIndex integer not null,
          $columnChapterUrl text not null,
          $columnChapterName text not null,
          $columnChapterContent text not null)
      ''');
  }

  static String tableName(BookInfo bookInfo) {
    return "${bookInfo.name}${bookInfo.author}";
  }

  Future<List<Chapter>> getChapters(BookInfo bookInfo) async {
    final db = await database;
    final cs = await db.query(tableName(bookInfo));
    if (cs == null) return null;
    List<Chapter> lc = [];
    for (var item in cs) {
      lc.add(Chapter.formMap(item));
    }
    return lc;
  }

  Future<int> deleteChapter(BookInfo bookInfo, int id) async {
    final db = await database;
    return await db.delete(tableName(bookInfo),
        where: "$columnChapterId = ?", whereArgs: [id]);
  }

  Future<void> addChapters(BookInfo bookInfo, List<Chapter> chapters) async {
    final db = await database;
    for (var item in chapters) {
      await db.insert(tableName(bookInfo), item.toMap());
    }
  }

  Future<int> updateChapter(BookInfo bookInfo, Chapter chapter) async {
    final db = await database;
    return await db.update(tableName(bookInfo), chapter.toMap(),
        where: "$columnChapterId = ?", whereArgs: [chapter.id]);
  }

  Future<void> clearChapters(BookInfo bookInfo) async {
    final db = await database;
    await db.delete(tableName(bookInfo));
  }
}
