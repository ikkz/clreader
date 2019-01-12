import 'package:flutter/material.dart';

import 'package:clreader/pages/drawer.dart';

class BookShelf extends StatefulWidget {
  @override
  _BookShelfState createState() {
    return new _BookShelfState();
  }
}

class _SearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(Icons.search)),
    ].toList();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: <Widget>[],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: <Widget>[],
    );
  }
}

class _BookShelfState extends State<BookShelf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("书架"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: _SearchDelegate(),
                );
              },
            ),
          ),
        ],
      ),
      drawer: new ClDrawer(),
    );
  }
}
