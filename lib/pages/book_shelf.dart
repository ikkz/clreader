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
  Widget _buildAppBar(BuildContext context) {
    final mainModel = ClMainModel.of(context);
    final bookShelves = mainModel.bookShelves;
    return new AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(mainModel.selectedBookShelf),
          IconButton(
            icon: Icon(Icons.arrow_drop_down),
            onPressed: () {
              var options = <Widget>[];
              bookShelves.forEach((String s, List<int> color) {
                options.add(SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context);
                      mainModel.setSelectedBookShelf(s);
                    },
                    child: s == mainModel.selectedBookShelf
                        ? ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(s),
                            trailing: Icon(Icons.check),
                          )
                        : ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(s))));
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                        titlePadding: EdgeInsets.all(0),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Text(
                                "请选择书架",
                                style: Theme.of(context).textTheme.title,
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        children: options);
                  });
            },
          )
        ],
      ),
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
    );
  }

  Widget _buildBody(BuildContext context) {
    var list = <Widget>[];
    final mainModel = ClMainModel.of(context);
    final books = mainModel.books;
    final bookShelves = mainModel.bookShelves;

    if (bookShelves.containsKey(mainModel.selectedBookShelf)) {
      bookShelves[mainModel.selectedBookShelf]?.forEach((int i) {
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
                    SizedBox.fromSize(
                      size: Size(50, 100),
                      child: CachedNetworkImage(
                        imageUrl: info.urlCover,
                        placeholder: new CircularProgressIndicator(),
                        errorWidget: new Icon(Icons.error),
                      ),
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
    }
    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: list,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        drawer: new ClDrawer(),
        body: _buildBody(context));
  }
}
