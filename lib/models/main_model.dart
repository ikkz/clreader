import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import 'package:clreader/models/book_shelves_model.dart';
import 'package:clreader/models/all_book_srcs_model.dart';
import 'package:clreader/models/all_books.dart';

class ClMainModel extends Model
    with BookShelvesModel, AllBookSrcsModel, AllBooksModel {
  ClMainModel() {
    bookShelvesModelLoad();
    allBookSrcsModelLoad();
    allBooksModelLoad();
  }

  notify() {
    notifyListeners();
  }

  static ClMainModel of(BuildContext context) {
    return ScopedModel.of<ClMainModel>(context, rebuildOnChange: true);
  }
}
