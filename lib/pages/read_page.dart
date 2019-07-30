import 'dart:async';
import 'package:flutter/material.dart';

import 'package:clreader/book/chapter.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/book/book_info.dart';

class ReadPage extends StatefulWidget {
  final BookInfo bookInfo;

  ReadPage({@required this.bookInfo});
  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  List<Chapter> chapters;
  int chapter;

  @override
  Widget build(BuildContext context) {
    final mainModel = ClMainModel.of(context);
    return chapters == null
        ? FutureBuilder(
            future: mainModel.getChapters(widget.bookInfo),
            builder: (context, AsyncSnapshot<List<Chapter>> ssChapters) {
              if (ssChapters.connectionState == ConnectionState.done) {
                chapters = ssChapters.data;
                return _buildPage();
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : _buildPage();
  }

  Future<String> _getContent(String url) async {
    final mainModel = ClMainModel.of(context);
    final src = await mainModel.getBookSrc(widget.bookInfo.srcId);
    if (src != null) {
      return await src.getContent(url);
    } else {
      return "";
    }
  }

  Widget _buildPage() {
    final mainModel = ClMainModel.of(context);
    if (chapter == null) {
      chapter = widget.bookInfo.curChapter;
    }
    if (chapter > chapters.length - 1 || chapter <= 0) {
      chapter = 1;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(chapters[chapter - 1].name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: previousChapter,
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: nextChapter,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(
                chapters[i].name,
                style: chapters[i].content.isEmpty
                    ? Theme.of(context)
                        .textTheme
                        .body1
                        .copyWith(color: Colors.grey)
                    : Theme.of(context).textTheme.body1,
              ),
              onTap: () {
                setState(() {
                  chapter = i + 1;
                });
                _chapterChanged();
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      body: (chapters[chapter - 1].content.isEmpty
          ? FutureBuilder(
              future: _getContent(chapters[chapter - 1].url),
              builder: (context, AsyncSnapshot<String> ssContent) {
                if (ssContent.connectionState == ConnectionState.done) {
                  chapters[chapter - 1].content = ssContent.data;
                  mainModel.updateChapter(
                      widget.bookInfo, chapters[chapter - 1]);
                  return _buildContent(ssContent.data);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : _buildContent(chapters[chapter - 1].content)),
    );
  }

  Widget _buildContent(String content) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            content,
            style: Theme.of(context).textTheme.body1.copyWith(height: 2),
          ),
        ),
      ),
    );
  }

  void nextChapter() {
    setState(() {
      chapter++;
      _chapterChanged();
    });
  }

  void previousChapter() {
    setState(() {
      chapter--;
      _chapterChanged();
    });
  }

  void _chapterChanged() {
    final mainModel = ClMainModel.of(context);
    widget.bookInfo.curChapter = chapter;
    mainModel.updateBook(widget.bookInfo);
  }
}
