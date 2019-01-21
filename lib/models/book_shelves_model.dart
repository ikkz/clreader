import 'dart:async';

import 'package:clreader/book/book_shelf.dart';
import 'package:clreader/models/base_model.dart';

class BookShelvesModel extends BaseModel {
  Future<BookShelf> insertBookShelf(BookShelf bookShelf) async {
    final db = await database;
    bookShelf.id = await db.insert(tableBookShelves, bookShelf.toMap());
    return bookShelf;
  }

  Future<BookShelf> getBookShelf(int id) async {
    final db = await database;
    List<Map> maps = await db.query(tableBookShelves,
        columns: [columnBookShelfId, columnBookShelfBookIds],
        where: "$columnBookShelfId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return BookShelf.fromMap(maps.first);
    }
    return null;
  }

  Future<List<BookShelf>> getBookShelves() async {
    final db = await database;
    List<Map> maps = await db.query(tableBookShelves);
    return maps.map((Map map) {
      return BookShelf.fromMap(map);
    });
  }

  Future<int> deleteBookShelf(int id) async {
    final db = await database;
    return await db.delete(tableBookShelves,
        where: "$columnBookShelfId = ?", whereArgs: [id]);
  }

  Future<int> updateBookShelf(BookShelf bookShelf) async {
    final db = await database;
    return await db.update(tableBookShelves, bookShelf.toMap(),
        where: "$columnBookShelfId = ?", whereArgs: [bookShelf.id]);
  }
}
