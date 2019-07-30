import 'dart:async';

import 'package:clreader/book/book_src.dart';
import 'package:clreader/models/base_model.dart';

class BookSrcsModel extends BaseModel {
  Future<BookSrc> insertBookSrc(BookSrc bookSrc) async {
    final db = await database;
    await db.insert(tableBookSrc, bookSrc.toMap());
    return bookSrc;
  }

  Future<List<BookSrc>> getBookSrcs() async {
    final db = await database;
    List<Map> maps = await db.query(tableBookSrc);
    return maps.map((map) {
      return BookSrc.fromMap(map);
    }).toList();
  }

  Future<BookSrc> getBookSrc(String sha) async {
    final db = await database;
    List<Map> maps = await db.query(tableBookSrc,
        columns: [
          columnBookSrcName,
          columnBookSrcEnabled,
          columnBookSrcJs,
          columnBookSrcSHA
        ],
        where: "$columnBookSrcSHA = ?",
        whereArgs: [sha]);
    return maps.length > 0 ? BookSrc.fromMap(maps.first) : null;
  }

  Future<int> deleteBookSrc(String sha) async {
    final db = await database;
    return await db
        .delete(tableBookSrc, where: "$columnBookSrcSHA = ?", whereArgs: [sha]);
  }

  Future<int> updateBookSrc(BookSrc bookSrc) async {
    final db = await database;
    return await db.update(tableBookSrc, bookSrc.toMap(),
        where: "$columnBookSrcSHA = ?", whereArgs: [bookSrc.sha]);
  }
}
