import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:clreader/models/test_data.dart';

class BookShelvesModel extends Model {
  final bookShelvesKey = "bookShelves";
  Map<String, List<int>> bookShelves = Map<String, List<int>>();

  bookShelvesModelLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString(bookShelvesKey) ?? "";
    if (!json.isEmpty) {
      bookShelves = JsonDecoder().convert(json);
    } else {
      bookShelves.clear();
    }

    //test
    List<int> li = <int>[];
    for (int i = 0; i < 20; i++) li.add(testBookInfo.id);
    bookShelves.addAll({"默认书架": li});

    notifyListeners();
  }

  bookShelvesModelSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(bookShelvesKey, JsonEncoder().convert(bookShelves));
  }

}
