import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:clreader/models/main_model.dart';
import 'package:clreader/book/book_info.dart';
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
    var list = <Widget>[];
    var books = ClMainModel.of(context).books;

    ClMainModel.of(context).bookShelves["默认书架"]?.forEach((int i) {
      if (books.containsKey(i)) {
        BookInfo info = books[i];
        list.add(GestureDetector(
          onTap: () {
            debugPrint("taped:${info.name}");
          },
          child: Card(
            margin: EdgeInsets.all(5),
            child: SizedBox.fromSize(
              size: Size.fromHeight(100),
              child: Row(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: info.urlCover,
                    placeholder: new CircularProgressIndicator(),
                    errorWidget: new Icon(Icons.error),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          info.name,
                          style: Theme.of(context).textTheme.subhead,
                        ),
                        Text(
                          info.author,
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        // Text(
                        //   info.introduction,
                        //   style: Theme.of(context).textTheme.body1,
                        //   overflow: TextOverflow.clip,
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
      }
    });
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
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: list,
        ),
      )),
    );
  }
}
