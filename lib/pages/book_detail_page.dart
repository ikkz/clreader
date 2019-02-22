import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'package:clreader/components/simple_dialogs.dart';
import 'package:clreader/book/book_info.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/book/chapter.dart';

class BookDetailPage extends StatefulWidget {
  final BookInfo bookInfo;
  @override
  _BookDetailPageState createState() => _BookDetailPageState();

  BookDetailPage({@required this.bookInfo});
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _BookDetailPageState extends State<BookDetailPage> {
  final double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _appBarHeight,
            pinned: _appBarBehavior == AppBarBehavior.pinned,
            floating: _appBarBehavior == AppBarBehavior.floating ||
                _appBarBehavior == AppBarBehavior.snapping,
            snap: _appBarBehavior == AppBarBehavior.snapping,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _addToBookShelf();
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
                title: const Text("目录"),
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Theme.of(context).appBarTheme.color,
                    ),
                    Container(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: 150,
                            child: CachedNetworkImage(
                              imageUrl: widget.bookInfo.urlCover,
                              placeholder: Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: Center(
                                child: Icon(Icons.error),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          widget.bookInfo.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subhead,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
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
                                  Container(height: 5),
                                  Text(
                                    widget.bookInfo.introduction,
                                    maxLines: 7,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.overline,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
          FutureBuilder(
            future: _getChapters(),
            builder: (context, AsyncSnapshot<List<Chapter>> ssChapters) {
              if (ssChapters.connectionState == ConnectionState.done) {
                if (ssChapters.data != null) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, i) {
                      return ListTile(
                        title: Text(
                            "${ssChapters.data[i].index.toString()}. ${ssChapters.data[i].name}"),
                        onTap: () {},
                      );
                    }, childCount: ssChapters.data.length),
                  );
                } else {
                  return SliverList(
                      delegate: SliverChildListDelegate(
                          <Widget>[Center(child: Icon(Icons.error))]));
                }
              } else {
                return SliverList(
                    delegate: SliverChildListDelegate(
                        <Widget>[Center(child: CircularProgressIndicator())]));
              }
            },
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
      return chapters;
    } else {
      final src = mainModel.getBookSrc(widget.bookInfo.srcId);
      if (src != null) {
        chapters = await src.getChapters(widget.bookInfo.srcsUrl[src.id]);
        mainModel.addChapters(widget.bookInfo, chapters);
        return chapters;
      }
    }
    return [];
  }

  Future<void> _addToBookShelf() async {
    final mainModel = ClMainModel.of(context);
    final bs = await mainModel.getBookShelves();
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("请选择书架"),
            children: bs.map((s) {
              return ListTile(
                title: Text(s.name),
                onTap: () async {
                  int id = widget.bookInfo.id;
                  if (id == null) {
                    id = (await mainModel.insertBook(widget.bookInfo)).id;
                  }
                  if (s.bookIds.indexOf(id) == -1) {
                    s.bookIds.insert(0, id);
                    mainModel.updateBookShelf(s);
                    Navigator.of(context).pop();
                  } else {
                    SimpleDialogs.alert(
                        context: context, title: "提示", content: "该书籍已存在");
                  }
                },
              );
            }).toList(),
          );
        });
  }
}
