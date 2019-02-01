import 'package:flutter/material.dart';

import 'package:clreader/book/book_shelf.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/components/book_shelf_item.dart';
import 'package:clreader/components/simple_dialogs.dart';
import 'package:clreader/constents.dart';

enum MenuItemType { SELECT_ALL, INVERT, DELETE, ADD, COMBINE }

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
        actions: <Widget>[
          PopupMenuButton<MenuItemType>(
            itemBuilder: (context) {
              return <PopupMenuEntry<MenuItemType>>[
                PopupMenuItem<MenuItemType>(
                  value: MenuItemType.SELECT_ALL,
                  child: Text("全选"),
                ),
                PopupMenuItem<MenuItemType>(
                  value: MenuItemType.INVERT,
                  child: Text("反选"),
                ),
                PopupMenuDivider(
                  height: 10,
                ),
                PopupMenuItem<MenuItemType>(
                  value: MenuItemType.ADD,
                  child: Text("添加"),
                ),
                PopupMenuItem<MenuItemType>(
                  value: MenuItemType.DELETE,
                  child: Text("删除"),
                ),
                PopupMenuItem<MenuItemType>(
                  value: MenuItemType.COMBINE,
                  child: Text("合并"),
                ),
              ];
            },
            onSelected: (type) {
              switch (type) {
                case MenuItemType.SELECT_ALL:
                  setState(() {
                    for (int i = 0; i < selected.length; i++) {
                      if (bookShelves[i].name != Strings.defaultBookShelf) {
                        selected[i] = true;
                      }
                    }
                  });
                  break;
                case MenuItemType.INVERT:
                  setState(() {
                    for (int i = 0; i < selected.length; i++) {
                      if (bookShelves[i].name != Strings.defaultBookShelf) {
                        selected[i] = !selected[i];
                      }
                    }
                  });
                  break;
                case MenuItemType.ADD:
                  SimpleDialogs.edit_text(
                          context: _thisContext,
                          title: "输入书架名称",
                          defaultText: "")
                      .then((value) {
                    if (value != null) {
                      if (!_checkTautonymy(value)) {
                        return;
                      }
                      var bookShelf = BookShelf();
                      bookShelf.name = value;
                      bookShelf.bookIds = [];
                      ClMainModel.of(_thisContext)
                          .insertBookShelf(bookShelf)
                          .then((value) {
                        _reload();
                      });
                    }
                  });
                  break;
                case MenuItemType.DELETE:
                  _deleteSelected();
                  break;
                case MenuItemType.COMBINE:
                  _combineSelected();
                  break;
                default:
              }
            },
          )
        ],
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
            if (bookShelves[i].name == Strings.defaultBookShelf) {
              SimpleDialogs.alert(
                  context: _thisContext, title: "提示", content: "不允许选中默认书架！");
              return;
            }
            setState(() {
              selected[i] = value;
            });
          },
          onEdit: bookShelves[i].name != Strings.defaultBookShelf
              ? () {
                  SimpleDialogs.edit_text(
                    context: _thisContext,
                    title: "修改书架名称",
                    defaultText: bookShelves[i].name,
                  ).then((value) {
                    if (value != null) {
                      if (!_checkTautonymy(value)) {
                        return;
                      }
                      setState(() {
                        bookShelves[i].name = value;
                      });
                      ClMainModel.of(_thisContext)
                          .updateBookShelf(bookShelves[i]);
                    }
                  });
                }
              : () {
                  SimpleDialogs.alert(
                      context: _thisContext,
                      title: "提示",
                      content: "不允许修改默认书架的名称！");
                },
        );
      },
    );
  }

  void _reload() {
    setState(() {
      bookShelves = null;
      selected.clear();
    });
  }

  void _deleteSelected() async {
    for (int i = 0; i < selected.length; i++) {
      if (selected[i]) {
        await ClMainModel.of(context).deleteBookShelf(bookShelves[i].id);
      }
    }
    _reload();
    _checkSeletedBookShelf();
    return;
  }

  void _combineSelected() async {
    SimpleDialogs.edit_text(context: context, title: "输入新书架名称", defaultText: "")
        .then((value) {
      if (value == null || value.isEmpty) {
        SimpleDialogs.alert(context: context, title: "提示", content: "不允许为空！");
        return;
      }
      if (!_checkTautonymy(value)) {
        return;
      }
      var bookShelf = BookShelf();
      bookShelf.name = value;
      bookShelf.bookIds = [];
      for (int i = 0; i < selected.length; i++) {
        if (selected[i]) {
          bookShelf.bookIds.addAll(bookShelves[i].bookIds);
        }
      }
      ClMainModel.of(context).insertBookShelf(bookShelf);
      _deleteSelected();
    });
  }

  bool _checkTautonymy(String name) {
    for (final item in bookShelves) {
      if (item.name == name) {
        SimpleDialogs.alert(
            context: context, title: "提示", content: "不允许与已有书架重名！");
        return false;
      }
    }
    return true;
  }

  void _checkSeletedBookShelf() async {
    final bookShelves = await ClMainModel.of(context).getBookShelves();
    final selected = await ClMainModel.of(context).selectedBookShelf;
    bool found = false;
    for (final item in bookShelves) {
      if (item.name == selected) {
        found = true;
      }
    }
    if (!found) {
      await ClMainModel.of(context)
          .setSelectedBookShelf(Strings.defaultBookShelf);
    }
  }
}
