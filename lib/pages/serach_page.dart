import 'package:flutter/material.dart';

import 'package:clreader/book/book_info.dart';
import 'package:clreader/components/book_item.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/pages/book_detail_page.dart';

class SearchPage extends StatefulWidget {
  final String searchText;
  final bool name;
  SearchPage({this.searchText, this.name});

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
    (await ClMainModel.of(context).bookSrcs).forEach((src) {
      src.search(
          name: widget.name ? widget.searchText : null,
          author: widget.name ? null : widget.searchText,
          callback: (info) {
            if (!mounted) {
              return false;
            }
            setState(() {
              _books.add(info);
            });
            return true;
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索: ${widget.searchText}"),
        actions: <Widget>[],
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
                return GestureDetector(
                  child: BookItem(
                    bookInfo: _books[i],
                  ),
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
