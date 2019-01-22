import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/constents.dart';

final String prefIsNightMode = "isNightMode";
final String prefThemeName = "themeName";
final String prefSelectedBookShelf = "selectedBookShelf";

class Preference extends BaseModel {
  Future<bool> get isNightMode async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(prefIsNightMode) ?? false;
  }

  Future<String> get themeName async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefThemeName) ?? "蓝色";
  }

  Future<String> get selectedBookShelf async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefSelectedBookShelf);
  }

  void setNightMode(bool isNightMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(prefIsNightMode, isNightMode);
    notifyListeners();
  }

  void setThemeName(String themeName) async {
    if (materialColorInfo.containsKey(themeName)) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(prefThemeName, themeName);
      notifyListeners();
    }
  }

  void setSelectedBookShelf(String selectedBookShelf) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefSelectedBookShelf, selectedBookShelf);
    notifyListeners();
  }
}
