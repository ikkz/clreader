import 'package:flutter/material.dart';

import 'package:clreader/constents.dart';
import 'package:clreader/pages/book_shelf.dart';

void main() => runApp(ClReader());

class ClReader extends StatefulWidget {
  @override
  ClReaderState createState() {
    return ClReaderState();
  }
}

class ClReaderState extends State<ClReader> {
  bool _isNightMode = false;
  String _themeName = "蓝色";

  bool get isNightMode => _isNightMode;
  String get themeName => _themeName;

  ThemeData get themeData => _isNightMode
      ? ThemeData.dark()
      : ThemeData(primarySwatch: materialColorInfo[_themeName]);

  void setNightMode(bool isNightMode) {
    if (isNightMode != _isNightMode) {
      setState(() {
        _isNightMode = isNightMode;
      });
    }
  }

  void setThemeName(String themeName) {
    if (themeName != _themeName && materialColorInfo.containsKey(themeName)) {
      setState(() {
        _themeName = themeName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationName,
      theme: this.themeData,
      home: new BookShelf(this),
    );
  }
}
