import 'package:flutter/material.dart';

import 'package:clreader/models/main_model.dart';
import 'package:clreader/book/book_info.dart';
import 'package:clreader/pages/drawer_page.dart';
import 'package:clreader/book/book_shelf.dart';
import 'package:clreader/components/book_item.dart';
import 'package:clreader/constents.dart';
import 'package:clreader/pages/serach_page.dart';
import 'package:clreader/pages/book_detail_page.dart';
import 'package:clreader/pages/read_page.dart';
import 'package:clreader/components/simple_dialogs.dart';

class BookShelfPage extends StatefulWidget {
  @override
  _BookShelfPageState createState() {
    return new _BookShelfPageState();
  }
}

class _BookShelfPageState extends State<BookShelfPage> {
  Widget _buildAppBar(BuildContext context) {
    final mainModel = ClMainModel.of(context);
    return new AppBar(
      title: FutureBuilder(
          future: mainModel.selectedBookShelf,
          builder: (context, AsyncSnapshot<String> ssSelectedBookShelf) {
            if (ssSelectedBookShelf.connectionState == ConnectionState.done) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(ssSelectedBookShelf.data ?? Strings.defaultBookShelf),
                  FutureBuilder(
                    future: mainModel.getBookShelves(),
                    builder: (context,
                        AsyncSnapshot<List<BookShelf>> ssBookShelves) {
                      if (ssBookShelves.connectionState ==
                          ConnectionState.done) {
                        return IconButton(
                          icon: Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            var options = <Widget>[];
                            ssBookShelves.data.forEach((BookShelf bookShelf) {
                              options.add(ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                title: Text(bookShelf.name),
                                trailing: bookShelf.name ==
                                        (ssSelectedBookShelf.data ??
                                            Strings.defaultBookShelf)
                                    ? Icon(Icons.check)
                                    : null,
                                onTap: () {
                                  Navigator.pop(context);
                                  mainModel
                                      .setSelectedBookShelf(bookShelf.name);
                                },
                              ));
                            });
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                      title: const Text("请选择书架"),
                                      children: options);
                                });
                          },
                        );
                      } else {
                        return IconButton(
                          icon: Icon(Icons.arrow_drop_down),
                          onPressed: () {},
                        );
                      }
                    },
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            String value = await SimpleDialogs.edit_text(
                context: context, title: "请输入书名", defaultText: "");
            if (value == null) {
              return;
            }
            if (value.isEmpty) {
              SimpleDialogs.alert(context: context, content: "请输入内容！");
              return;
            }
            final bookSrcs = await mainModel.getBookSrcs();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return SearchPage(
                searchText: value,
                bookSrcs: bookSrcs,
              );
            }));
          },
        ),
      ],
    );
  }

  Widget _buildBookShelf(BuildContext context) {
    final mainModel = ClMainModel.of(context);

    return FutureBuilder(
      future: mainModel.getBooks(),
      builder: (context, AsyncSnapshot<List<BookInfo>> ssBooks) {
        if (ssBooks.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: mainModel.getBookShelves(),
            builder: (context, AsyncSnapshot<List<BookShelf>> ssBookShelves) {
              if (ssBookShelves.connectionState == ConnectionState.done) {
                return FutureBuilder(
                  future: mainModel.selectedBookShelf,
                  builder:
                      (context, AsyncSnapshot<String> ssSelectedBookShelf) {
                    if (ssSelectedBookShelf.connectionState ==
                        ConnectionState.done) {
                      BookShelf bookShelf;
                      for (var item in ssBookShelves.data) {
                        if (item.name ==
                            (ssSelectedBookShelf.data ??
                                Strings.defaultBookShelf)) {
                          bookShelf = item;
                          break;
                        }
                      }
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        itemCount: bookShelf.bookIds.length,
                        itemBuilder: (context, i) {
                          BookInfo info = null;
                          for (var book in ssBooks.data) {
                            if (book.id == bookShelf.bookIds[i]) {
                              info = book;
                              break;
                            }
                          }
                          return BookItem(
                            bookInfo: info,
                            onTap: () => readBook(info),
                            onMoreTap: () {
                              showMore(context, bookShelf, info);
                            },
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return _buildBookShelf(context);
  }

  void readBook(BookInfo bookInfo) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ReadPage(
        bookInfo: bookInfo,
      );
    }));
  }

  void showMore(BuildContext context, BookShelf bookShelf, BookInfo bookInfo) {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("详情"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return BookDetailPage(
                      bookInfo: bookInfo,
                    );
                  }));
                },
              ),
              ListTile(
                title: const Text("阅读"),
                onTap: () {
                  Navigator.of(context).pop();
                  readBook(bookInfo);
                },
              ),
              ListTile(
                title: Text("从此书架移除"),
                onTap: () {
                  bookShelf.bookIds
                      .removeAt(bookShelf.bookIds.indexOf(bookInfo.id));
                  ClMainModel.of(context).updateBookShelf(bookShelf);
                  ClMainModel.of(context).notifyListeners();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        drawer: new DrawerPage(),
        body: _buildBody(context));
  }
}
