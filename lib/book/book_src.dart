import 'dart:async';

import 'package:clreader/book/book_info.dart';

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

  Future<List<BookInfo>> search({String name, String author}) async {
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
