import 'dart:async';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/book/book_info.dart';

class BooksModel extends BaseModel {
  Future<BookInfo> insertBook(BookInfo bookInfo) async {
    final db = await database;
    bookInfo.id = await db.insert(tableBooks, bookInfo.toMap());
    return bookInfo;
  }

  Future<BookInfo> getBook(int id) async {
    final db = await database;
    List<Map> maps = await db.query(tableBooks,
        columns: [
          columnBookId,
          columnBookName,
          columnBookAuthor,
          columnBookCoverUrl,
          columnBookIntroduction,
          cloumnBookSrc
        ],
        where: "$columnBookId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return BookInfo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<BookInfo>> getBooks() async {
    final db = await database;
    List<Map> maps = await db.query(tableBooks);
    List<BookInfo> books = [];
    maps.forEach((map) {
      books.add(BookInfo.fromMap(map));
    });
    return books;
  }

  Future<int> deleteBook(int id) async {
    final db = await database;
    return await db
        .delete(tableBooks, where: "$columnBookId = ?", whereArgs: [id]);
  }

  Future<int> updateBook(BookInfo bookInfo) async {
    final db = await database;
    return await db.update(tableBooks, bookInfo.toMap(),
        where: "$columnBookId = ?", whereArgs: [bookInfo.id]);
  }
}
