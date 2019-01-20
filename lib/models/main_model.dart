import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/models/book_shelves_model.dart';
import 'package:clreader/models/book_srcs_model.dart';
import 'package:clreader/models/books_model.dart';

class ClMainModel extends BaseModel
    with BookShelvesModel, BookSrcsModel, BooksModel {
  ClMainModel() {}

  init() async {
    await Sqflite.setDebugModeOn(true);
    await openDb();
  }

  static ClMainModel of(BuildContext context) {
    return ScopedModel.of<ClMainModel>(context, rebuildOnChange: true);
  }
}
