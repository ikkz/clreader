import 'package:clreader/book/book_src.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/models/book_shelves_model.dart';
import 'package:clreader/models/book_srcs_model.dart';
import 'package:clreader/models/books_model.dart';
import 'package:clreader/models/preference.dart';
import 'package:clreader/constents.dart';

import 'package:clreader/book/book_shelf.dart';
import 'package:clreader/models/chapter_mgr.dart';

class ClMainModel extends BaseModel
    with BookShelvesModel, BookSrcsModel, BooksModel, ChapterMgr, Preference {
  ClMainModel._();

  static Future<ClMainModel> _initMainModel() async {
    _instance = ClMainModel._();
    await _instance.initPref();
    var bookShelves = await _instance.getBookShelves();
    if (bookShelves.isEmpty) {
      await _instance.insertBookShelf(
          BookShelf(name: Strings.defaultBookShelf, bookIds: []));
    }
    return _instance;
  }

  static ClMainModel _instance;

  static Future<ClMainModel> get instance async =>
      _instance ?? await _initMainModel();

  static ClMainModel of(BuildContext context) {
    return ScopedModel.of<ClMainModel>(context, rebuildOnChange: true);
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
