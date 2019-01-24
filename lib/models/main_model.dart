import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/models/book_shelves_model.dart';
import 'package:clreader/models/book_srcs_model.dart';
import 'package:clreader/models/books_model.dart';
import 'package:clreader/models/preference.dart';

//test
import 'package:clreader/book/book_shelf.dart';
import 'test_data.dart';

class ClMainModel extends BaseModel
    with BookShelvesModel, BookSrcsModel, BooksModel, Preference {
  ClMainModel._() ;

  static Future<ClMainModel> _initMainModel() async {
    _instance = ClMainModel._();
    await _instance.initIsNightMode();
    await _instance.initThemeName();
    //test
    var books = await _instance.getBooks();
    if(books.isEmpty){
      await _instance.insertBook(testBookInfo);
    }
    var bookShelves = await _instance.getBookShelves();
    if(bookShelves.isEmpty){
      await _instance.insertBookShelf(BookShelf(name: "默认书架", bookIds: []));
    }
    if(bookShelves.length == 1){
      await _instance.insertBookShelf(BookShelf(name: "bf1", bookIds: [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]));
      await _instance.insertBookShelf(BookShelf(name: "bf2", bookIds: [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]));
      await _instance.insertBookShelf(BookShelf(name: "bf3", bookIds: [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]));
      await _instance.insertBookShelf(BookShelf(name: "bf4", bookIds: [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]));
      await _instance.insertBookShelf(BookShelf(name: "bf5", bookIds: [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]));
    }
    return _instance;
  }

  static ClMainModel _instance;

  static Future<ClMainModel> get instance async => _instance ?? await _initMainModel();

  static ClMainModel of(BuildContext context) {
    return ScopedModel.of<ClMainModel>(context, rebuildOnChange: true);
  }
}
