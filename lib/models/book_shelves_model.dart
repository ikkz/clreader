import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:clreader/models/test_data.dart';

class BookShelvesModel extends Model {
  static final bookShelvesKey = "bookShelves";
  Map<String, List<int>> bookShelves = Map<String, List<int>>();

  static final String selectedBookShelfKey = "selectedBookShelf";
  static final String defalutBookShelf = "默认书架";
  String selectedBookShelf = defalutBookShelf;

  bookShelvesModelLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString(bookShelvesKey) ?? "";
    if (!json.isEmpty) {
      bookShelves = JsonDecoder().convert(json);
    } else {
      bookShelves.clear();
    }
    selectedBookShelf =
        prefs.getString(selectedBookShelfKey) ?? defalutBookShelf;

    //test
    List<int> li = <int>[];
    for (int i = 0; i < 20; i++) {
      li.add(testBookInfo.id);
    }
    bookShelves.addAll({defalutBookShelf: li});
    bookShelves.addAll({"书架一": li});
    bookShelves.addAll({"书架二": li});
    bookShelves.addAll({"书架三": li});
    bookShelves.addAll({"书架四": li});
    bookShelves.addAll({"书架五": li});
    bookShelves.addAll({"书架六": li});
    bookShelves.addAll({"书架七": li});
    bookShelves.addAll({"书架八": li});

    if (bookShelves.length == 0) {
      bookShelves.addAll({defalutBookShelf: <int>[]});
    }
    notifyListeners();
  }

  setSelectedBookShelf(String s) async {
    selectedBookShelf = s;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(selectedBookShelfKey, selectedBookShelf);
  }

  bookShelvesModelSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(bookShelvesKey, JsonEncoder().convert(bookShelves));
  }
}
