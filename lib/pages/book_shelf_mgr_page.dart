import 'package:flutter/material.dart';

import 'package:clreader/book/book_shelf.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/components/book_shelf_item.dart';
import 'package:clreader/components/text_edit_dialog.dart';
import 'package:clreader/constents.dart';

class BookShelfMgrPage extends StatefulWidget {
  @override
  _BookShelfMgrPageState createState() {
    return _BookShelfMgrPageState();
  }
}

class _BookShelfMgrPageState extends State<BookShelfMgrPage> {
  List<BookShelf> bookShelves;
  List<bool> selected = [];
  BuildContext _thisContext;
  @override
  Widget build(BuildContext context) {
    _thisContext = context;
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
          onEdit: bookShelves[i].name != Strings.defaultBookShelf
              ? () {
                  showDialog<String>(
                      context: _thisContext,
                      builder: (context) {
                        return TextEditDiaglog(
                          title: "修改书架名称",
                          defaultText: bookShelves[i].name,
                        );
                      }).then((value) {
                    if (value != null) {
                      setState(() {
                        bookShelves[i].name = value;
                      });
                      ClMainModel.of(_thisContext)
                          .updateBookShelf(bookShelves[i]);
                    }
                  });
                }
              : () {
                  showDialog(
                      context: _thisContext,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("提示"),
                          content: Text("不允许修改默认书架的名称！"),
                        );
                      });
                },
        );
      },
    );
  }
}
