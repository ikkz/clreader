import 'dart:async';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/book/book_info.dart';

class BooksModel extends BaseModel {
  Future<BookInfo> insertBook(BookInfo bookInfo) async {
    if (database == null) {
      return null;
    }
    bookInfo.id = await database.insert(tableBooks, bookInfo.toMap());
    return bookInfo;
  }

  Future<BookInfo> getBook(int id) async {
    if (database == null) {
      return null;
    }
    List<Map> maps = await database.query(tableBooks,
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
    if (database == null) {
      return null;
    }
    List<Map> maps = await database.query(tableBooks);
    return maps.map((Map map) {
      return BookInfo.fromMap(map);
    });
  }

  Future<int> deleteBook(int id) async {
    if (database == null) {
      return null;
    }
    return await database
        .delete(tableBooks, where: "$columnBookId = ?", whereArgs: [id]);
  }

  Future<int> updateBook(BookInfo bookInfo) async {
    if (database == null) {
      return null;
    }
    return await database.update(tableBooks, bookInfo.toMap(),
        where: "$columnBookId = ?", whereArgs: [bookInfo.id]);
  }
}
