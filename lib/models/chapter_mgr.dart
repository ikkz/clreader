import 'dart:async';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/book/book_info.dart';
import 'package:clreader/book/chapter.dart';

class ChapterMgr extends BaseModel {
  Future<void> createChapters(BookInfo bookInfo) async {
    final db = await database;
    final table = await db.query(bookInfo.name);
    if (table != null) {
      return;
    } else {
      await db.execute('''
        create table ${bookInfo.name} (
          $columnChapterId integer primary key autoincrement,
          $columnChapterIndex integer not null,
          $columnChapterUrl text not null,
          $columnChapterName text not null,
          $columnChapterContent text not null)
      ''');
      return;
    }
  }

  Future<List<Chapter>> getChapters(BookInfo bookInfo) async {
    final db = await database;
    final cs = await db.query(bookInfo.name);
    if (cs == null) return null;
    List<Chapter> lc = [];
    for (var item in cs) {
      lc.add(Chapter.formMap(item));
    }
    return lc;
  }

  Future<int> deleteChapter(BookInfo bookInfo, int id) async {
    final db = await database;
    return await db
        .delete(bookInfo.name, where: "$columnChapterId = ?", whereArgs: [id]);
  }

  Future<int> updateChapter(BookInfo bookInfo, Chapter chapter) async {
    final db = await database;
    return await db.update(bookInfo.name, chapter.toMap(),
        where: "$columnChapterId = ?", whereArgs: [chapter.id]);
  }

  Future<void> clearChapters(BookInfo bookInfo) async {
    final cs = await getChapters(bookInfo);
    if (cs != null) {
      for (var item in cs) {
        await deleteChapter(bookInfo, item.id);
      }
    }
  }
}
