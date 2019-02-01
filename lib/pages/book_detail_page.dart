import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'package:clreader/book/book_info.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/book/chapter.dart';

class BookDetailPage extends StatefulWidget {
  final BookInfo bookInfo;
  @override
  _BookDetailPageState createState() => _BookDetailPageState();

  BookDetailPage({@required this.bookInfo});
}

class _BookDetailPageState extends State<BookDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书籍信息"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            height: 150,
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          widget.bookInfo.name,
                          style: Theme.of(context).textTheme.subhead,
                        ),
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
                            widget.bookInfo.author,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      Divider(
                        height: 2,
                      ),
                      Expanded(
                        flex: 1,
                        child: Scrollbar(
                          child: SingleChildScrollView(
                            child: Text(widget.bookInfo.introduction),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    color: Theme.of(context).dialogBackgroundColor,
                    height: 150,
                    width: 110,
                    child: CachedNetworkImage(
                      imageUrl: widget.bookInfo.urlCover,
                      placeholder: Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: Center(
                        child: Icon(Icons.error),
                      ),
                    )),
              ],
            ),
          ),
          Divider(
            height: 2,
          ),
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: _getChapters(),
              builder: (context, AsyncSnapshot<List<Chapter>> ssChapters) {
                if (ssChapters.connectionState == ConnectionState.done) {
                  if (ssChapters.data != null) {
                    return Scrollbar(
                      child: ListView.builder(
                        itemCount: ssChapters.data.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            title: Text(
                                "${ssChapters.data[i].index.toString()}. ${ssChapters.data[i].name}"),
                            onTap: () {},
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: Icon(Icons.error),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<List<Chapter>> _getChapters() async {
    final mainModel = ClMainModel.of(context);
    mainModel.createChapters(widget.bookInfo);
    var chapters = await mainModel.getChapters(widget.bookInfo);
    if (chapters != null && chapters.isNotEmpty) {
      print("db");
      return chapters;
    } else {
      final src = mainModel.getBookSrc(widget.bookInfo.srcId);
      if (src != null) {
        print("net");
        chapters = await src.getChapters(widget.bookInfo.srcsUrl[src.id]);
        mainModel.addChapters(widget.bookInfo, chapters);
        return chapters;
      }
    }
    return [];
  }
}
