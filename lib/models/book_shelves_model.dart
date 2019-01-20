import 'dart:async';

import 'package:clreader/book/book_shelf.dart';
import 'package:clreader/models/base_model.dart';

class BookShelvesModel extends BaseModel {
  Future<BookShelf> insertBookShelf(BookShelf bookShelf) async {
    if (database == null) {
      return null;
    }
    bookShelf.id = await database.insert(tableBookShelves, bookShelf.toMap());
    return bookShelf;
  }

  Future<BookShelf> getBookShelf(int id) async {
    if (database == null) {
      return null;
    }
    List<Map> maps = await database.query(tableBookShelves,
        columns: [columnBookShelfId, columnBookShelfBookIds],
        where: "$columnBookShelfId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return BookShelf.fromMap(maps.first);
    }
    return null;
  }

  Future<List<BookShelf>> getBookShelves() async {
    if (database == null) {
      return null;
    }
    List<Map> maps = await database.query(tableBookShelves);
    return maps.map((Map map) {
      return BookShelf.fromMap(map);
    });
  }

  Future<int> deleteBookShelf(int id) async {
    if (database == null) {
      return null;
    }
    return await database.delete(tableBookShelves,
        where: "$columnBookShelfId = ?", whereArgs: [id]);
  }

  Future<int> updateBookShelf(BookShelf bookShelf) async {
    if (database == null) {
      return null;
    }
    return await database.update(tableBookShelves, bookShelf.toMap(),
        where: "$columnBookShelfId = ?", whereArgs: [bookShelf.id]);
  }
}
