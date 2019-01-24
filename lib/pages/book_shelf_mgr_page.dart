import 'package:flutter/material.dart';

import 'package:clreader/book/book_shelf.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/components/book_shelf_item.dart';

class BookShelfMgrPage extends StatefulWidget {
  @override
  _BookShelfMgrPageState createState() {
    return _BookShelfMgrPageState();
  }
}

class _BookShelfMgrPageState extends State<BookShelfMgrPage> {
  List<BookShelf> bookShelves;
  List<bool> selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书架管理"),
      ),
      body: bookShelves == null
          ? FutureBuilder(
              future: ClMainModel.of(context).getBookShelves(),
              builder: (context, AsyncSnapshot<List<BookShelf>> ssBookShelves) {
                if (ssBookShelves.connectionState == ConnectionState.done) {
                  for (int i = 0; i < ssBookShelves.data.length; i++) {
                    selected.add(false);
                  }
                  bookShelves = ssBookShelves.data;
                  return _buildList(context);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: selected.length,
      itemBuilder: (context, i) {
        return BookShelfItem(
          selected: selected[i],
          bookShelf: bookShelves[i],
          onCheckboxChanged: (value) {
            setState(() {
              selected[i] = value;
            });
          },
          onEdit: () {
            //TODO: onEdit
          },
        );
      },
    );
  }
}
