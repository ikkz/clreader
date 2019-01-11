import 'package:flutter/material.dart';
import 'constents.dart';
import 'pages/book_shelf.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: applicationName,
      theme: ThemeData.dark(),
      home: new BookShelf(),
    );
  }
}
