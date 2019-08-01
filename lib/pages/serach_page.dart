import 'package:flutter/material.dart';

import 'package:clreader/book/book_info.dart';
import 'package:clreader/components/book_item.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/pages/book_detail_page.dart';
import 'package:clreader/book/book_src.dart';

class SearchPage extends StatefulWidget {
  final String searchText;
  final List<BookSrc> bookSrcs;

  SearchPage({this.searchText, @required this.bookSrcs});

  @override
  _SearchPageState createState() => _SearchPageState();
}

enum BookSrcState { PREPARE, SEARCHING, FINISHED }

class _SearchPageState extends State<SearchPage> {
  bool _searched = false;
  List<BookSrcState> _states = [];
  List<BookInfo> _books = [];

  @override
  void initState() {
    super.initState();
    _states.length = widget.bookSrcs.length;
    _states.fillRange(0, widget.bookSrcs.length, BookSrcState.PREPARE);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_searched) {
      _search();
      _searched = true;
    }
  }

  void _search() async {
    for (int i = 0; i < widget.bookSrcs.length; i++) {
      if (widget.bookSrcs[i].enabled)
        widget.bookSrcs[i].search(widget.searchText).then((books) {
          this.setState(() {
            _books.addAll(books);
            _states[i] = BookSrcState.FINISHED;
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("搜索: ${widget.searchText}"),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 3,
              child: LinearProgressIndicator(),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, i) {
                  return BookItem(
                    bookInfo: _books[i],
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return BookDetailPage(
                          bookInfo: _books[i],
                        );
                      }));
                    },
                  );
                },
              ),
            )
          ],
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
              child: Icon(Icons.info),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ListView.builder(
                        itemCount: _states.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text(widget.bookSrcs[i].name),
                            trailing: Container(
                              width: 20,
                              height: 20,
                              child: _states[i] == BookSrcState.FINISHED
                                  ? Icon(Icons.check)
                                  : CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                            ),
                          );
                        },
                      );
                    });
              });
        }));
  }
}
