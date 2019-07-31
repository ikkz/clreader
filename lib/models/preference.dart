import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:clreader/models/base_model.dart';
import 'package:clreader/constents.dart';

final String prefIsNightMode = "isNightMode";
final String prefThemeName = "themeName";
final String prefSelectedBookShelf = "selectedBookShelf";
final String prefSrcRepo = "srcRepo";

class Preference extends BaseModel {
  bool isNightMode;
  String themeName;
  String srcRepo;

  void initPref() async {
    final prefs = await SharedPreferences.getInstance();
    isNightMode = prefs.getBool(prefIsNightMode) ?? false;
    themeName = prefs.getString(prefThemeName) ?? "蓝色";
    srcRepo = prefs.getString(prefSrcRepo) ?? Strings.defaultSrcRepo;
  }

  Future<String> get selectedBookShelf async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(prefSelectedBookShelf) ?? Strings.defaultBookShelf;
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

  void setSrcRepo(String srcRepo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(prefSrcRepo, srcRepo);
    this.srcRepo = srcRepo;
    notifyListeners();
  }
}
