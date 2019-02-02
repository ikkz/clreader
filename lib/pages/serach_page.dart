import 'package:flutter/material.dart';

import 'package:clreader/book/book_info.dart';
import 'package:clreader/components/book_item.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/pages/book_detail_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<BookInfo> _books = [];
  String _searchText = "";
  int searchId = 0;
  bool showCpi = false;

  void _search() async {
    if (_searchText.isEmpty) {
      return;
    }
    if (mounted) {
      setState(() {
        _books.clear();
        showCpi = true;
      });
    } else {
      return;
    }
    searchId++;
    (await ClMainModel.of(context).bookSrcs).forEach((src) {
      src.search(
          name: _searchText,
          searchId: searchId,
          callback: (info, id) {
            if (id != this.searchId || (!mounted)) {
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
        title: TextField(
          onChanged: (text) {
            _searchText = text;
          },
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _search();
                },
              )),
        ],
      ),
      body: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            child: BookItem(
              bookInfo: _books[i],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return BookDetailPage(
                  bookInfo: _books[i],
                );
              }));
            },
          );
        },
      ),
    );
  }
}
