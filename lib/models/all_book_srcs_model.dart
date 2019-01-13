import 'package:scoped_model/scoped_model.dart';
import 'package:clreader/book/book_src.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class AllBookSrcsModel extends Model {
  static final String srcsEnableKey = "srcsEnable";
  Map<int, bool> srcsEnable = Map<int, bool>();
  Map<int, BookSrc> srcs = Map<int, BookSrc>();

  allBookSrcsModelLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString(srcsEnableKey) ?? "";
    if (!json.isEmpty) {
      srcsEnable = JsonDecoder().convert(json);
    } else {
      srcsEnable = srcs.map((id, src) => MapEntry<int, bool>(id, true));
    }
    notifyListeners();
  }

  allBookSrcsModelSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(srcsEnableKey, JsonEncoder().convert(srcsEnable));
  }
}
