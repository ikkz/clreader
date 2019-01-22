import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/constents.dart';

final String prefIsNightMode = "isNightMode";
final String prefThemeName = "themeName";
final String prefSelectedBookShelf = "selectedBookShelf";

class Preference extends BaseModel {
  bool isNightMode;
  String themeName;

  void initIsNightMode() async {
    final prefs = await SharedPreferences.getInstance();
    isNightMode = prefs.getBool(prefIsNightMode) ?? false;
  }

  void initThemeName() async {
    final prefs = await SharedPreferences.getInstance();
    themeName = prefs.getString(prefThemeName) ?? "蓝色";
  }

  Future<String> get selectedBookShelf async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefSelectedBookShelf) ?? "默认书架";
  }

  void setNightMode(bool isNightMode) async {
    this.isNightMode = isNightMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(prefIsNightMode, isNightMode);
  }

  void setThemeName(String themeName) async {
    if (materialColorInfo.containsKey(themeName)) {
      this.themeName = themeName;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(prefThemeName, themeName);
    }
  }

  void setSelectedBookShelf(String selectedBookShelf) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefSelectedBookShelf, selectedBookShelf);
    notifyListeners();
  }
}
