import 'package:flutter/material.dart';
import 'Drawer.dart';

class BookShelf extends StatefulWidget {
  @override
  _BookShelfState createState() {
    return new _BookShelfState();
  }
}

class _BookShelfState extends State<BookShelf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: Text("书架")), drawer: new ClDrawer());
  }
}
