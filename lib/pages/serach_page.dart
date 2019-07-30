import 'package:flutter/material.dart';

import 'package:clreader/book/book_info.dart';
import 'package:clreader/components/book_item.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/pages/book_detail_page.dart';

class SearchPage extends StatefulWidget {
  final String searchText;
  SearchPage({this.searchText});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _searched = false;
  List<BookInfo> _books = [];

  @override
  void initState() {
    super.initState();
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
    (await ClMainModel.of(context).getBookSrcs()).forEach((src) {
      this.setState(() async {
        _books.addAll(await src.search(widget.searchText));
      });
    });
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
    );
  }
}
