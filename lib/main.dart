import 'package:flutter/material.dart';
import 'Config.dart';
import 'pages/BookShelf.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationName,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: new BookShelf(),
    );
  }
}
