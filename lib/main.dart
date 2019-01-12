import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clreader/constents.dart';
import 'package:clreader/pages/book_shelf.dart';

void main() => runApp(ClReader());

class ClReader extends StatefulWidget {
  @override
  ClReaderState createState() {
    return ClReaderState();
  }
}

class ClReaderStateShare extends InheritedWidget {
  ClReaderStateShare({@required this.state, Widget child})
      : super(child: child);

  final ClReaderState state;

  static ClReaderStateShare of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(ClReaderStateShare);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
  
}

class ClReaderState extends State<ClReader> {
  bool _isNightMode = false;
  String _themeName = "蓝色";

  @override
  void initState() {
    super.initState();
    _loadThemeInfo();
  }

  _loadThemeInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNightMode = prefs.getBool("isNightMode") ?? false;
      _themeName = prefs.getString("themeName") ?? "蓝色";
    });
  }

  bool get isNightMode => _isNightMode;
  String get themeName => _themeName;

  void setNightMode(bool isNightMode) async {
    if (isNightMode != _isNightMode) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _isNightMode = isNightMode;
        prefs.setBool("isNightMode", _isNightMode);
      });
    }
  }

  void setThemeName(String themeName) async {
    if (themeName != _themeName && materialColorInfo.containsKey(themeName)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _themeName = themeName;
        prefs.setString("themeName", _themeName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClReaderStateShare(
        state: this,
        child: MaterialApp(
          title: applicationName,
          theme: _isNightMode
              ? ThemeData.dark()
              : ThemeData(primarySwatch: materialColorInfo[_themeName]),
          home: new BookShelf(),
        ));
  }
}
