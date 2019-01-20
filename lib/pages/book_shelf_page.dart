import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:clreader/models/main_model.dart';
import 'package:clreader/book/book_info.dart';
import 'package:clreader/pages/drawer_page.dart';

class BookShelfPage extends StatefulWidget {
  @override
  _BookShelfPageState createState() {
    return new _BookShelfPageState();
  }
}

class _BookShelfPageState extends State<BookShelfPage> {
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
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildBookShelf(BuildContext context) {
    final mainModel = ClMainModel.of(context);
    final books = mainModel.books;
    final selectedBookShelf =
        mainModel.bookShelves[mainModel.selectedBookShelf];

    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: selectedBookShelf?.length ?? 0,
      itemBuilder: (context, i) {
        BookInfo info = books[selectedBookShelf[i]];
        return Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                height: 100,
                width: 80,
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: info.urlCover,
                  placeholder: CircularProgressIndicator(),
                  errorWidget: Icon(Icons.error),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        info.name,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 7,
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 14,
                            ),
                          ),
                          Container(
                            width: 5,
                          ),
                          Text(
                            info.author,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(height: 5),
                      Text(
                        info.introduction,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.overline,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return _buildBookShelf(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        drawer: new DrawerPage(),
        body: _buildBody(context));
  }
}
