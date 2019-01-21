import 'dart:async';

import 'package:clreader/book/book_info.dart';

class BookSrc {
  //using guid as primary key;
  String _id;
  bool _enabled = true;
  String _name;

  String get id => _id;
  bool get enabled => _enabled;
  String get name => _name;

  Future<List<BookInfo>> search({String name, String author}) async {
    return null;
  }
}
