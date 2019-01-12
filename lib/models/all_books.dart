import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:clreader/book/book_info.dart';

import 'package:clreader/models/test_data.dart';

class AllBooksModel extends Model {
  final booksKey = "books";
  Map<int, BookInfo> books = Map<int, BookInfo>();

  allBooksModelLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString(booksKey) ?? "";
    if (!json.isEmpty) {
      books = JsonDecoder().convert(json);
    } else {
      books.clear();
    }
    //test
    books.addAll({testBookInfo.id: testBookInfo});

    notifyListeners();
  }

  allBooksModelSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(booksKey, JsonEncoder().convert(books));
  }

}
