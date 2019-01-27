import 'dart:async';

import 'package:clreader/book/book_src.dart';
import 'package:clreader/models/base_model.dart';

class BookSrcsModel extends BaseModel {
  List<BookSrc> _bookSrcs;

  Future<List<BookSrc>> get bookSrcs async => _bookSrcs ?? await init();

  Future<List<BookSrc>> init() async {
    final db = await database;
    List<BookSrc> config = (await db.query(tableBookSrc)).map((Map map) {
      return BookSrc.fromMap(map);
    });
    Map<String, bool> configs = {};
    for (var item in config) {
      configs[item.id] = item.enabled;
    }
    List<BookSrc> srcs = _initBookSrcList();
    for (var item in srcs) {
      if (configs.containsKey(item.id)) {
        item.enabled = configs[item.id];
      }
    }
    return srcs;
  }

  List<BookSrc> _initBookSrcList() {
    List<BookSrc> srcs = [];
    //to add subtype of BookSrc here
    return srcs;
  }

  void updateBookSrc(BookSrc bookSrc) async {
    final db = await database;
    List<Map> maps = await db.query(tableBookSrc,
        columns: [columnBookSrcId, columnBookSrcEnabled],
        where: "$columnBookSrcId = ?",
        whereArgs: [bookSrc.id]);
    if (maps.isEmpty) {
      db.insert(tableBookSrc, bookSrc.toMap());
    } else {
      db.update(tableBookSrc, bookSrc.toMap(),
          where: "$columnBookSrcId = ? ", whereArgs: [bookSrc.id]);
    }
  }

  BookSrc getBookSrc(String id) {
    for (var item in _bookSrcs) {
      if (id == item.id) {
        return item;
      }
    }
    return null;
  }
}
