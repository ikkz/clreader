import 'dart:async';

import 'package:clreader/book/book_info.dart';
import 'package:clreader/book/chapter.dart';

typedef BookCallback = bool Function(BookInfo);

final String tableBookSrc = "bookSrcs";
final String columnBookSrcId = "_id";
final String columnBookSrcEnabled = "enabled";

class BookSrc {
  //using guid as primary key;
  String _id;
  bool enabled = true;
  String _name;

  String get id => _id;
  String get name => _name;
  set id(String id) => _id = id;
  set name(String name) => _name = name;

  Future<void> search(
      {String name, String author, BookCallback callback}) async {
    return null;
  }

  Future<List<Chapter>> getChapters(String bookUrl) async {
    return null;
  }

  Future<String> getContent(String contentUrl) async {
    return null;
  }

  BookSrc();

  BookSrc.fromMap(Map<String, dynamic> map)
      : _id = map[columnBookSrcId],
        enabled = map[columnBookSrcEnabled] == 1;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnBookSrcEnabled: enabled ? 1 : 0};
    if (_id != null) {
      map[columnBookSrcId] = _id;
    }
    return map;
  }
}
