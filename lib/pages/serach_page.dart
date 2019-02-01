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

  void _search() async {
    if (_searchText.isEmpty) {
      return;
    }
    print("text:$_searchText");
    if (mounted) {
      setState(() {
        _books.clear();
      });
    }
    (await ClMainModel.of(context).bookSrcs).forEach((src) {
      src.search(
          name: _searchText,
          callback: (info) {
            if (mounted) {
              setState(() {
                _books.add(info);
              });
            }
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textInputAction: TextInputAction.search,
          onChanged: (text) {
            _searchText = text;
          },
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
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
