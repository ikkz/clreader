import 'dart:async';
import 'dart:convert';

import 'package:clreader/book/book_info.dart';
import 'package:clreader/book/chapter.dart';
import 'package:clreader/platform/src_run.dart' as run;

final String tableBookSrc = "bookSrcs";
final String columnBookSrcName = "name";
final String columnBookSrcEnabled = "enabled";
final String columnBookSrcJs = "js";
final String columnBookSrcSHA = "sha";

class BookSrc {
  bool enabled;
  String name;
  String js;
  String sha;

  BookSrc({this.name, this.js, this.enabled, this.sha});

  BookSrc.fromMap(Map<String, dynamic> map)
      : name = map[columnBookSrcName],
        enabled = map[columnBookSrcEnabled] == 1,
        js = map[columnBookSrcJs],
        sha = map[columnBookSrcSHA];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnBookSrcName: name,
      columnBookSrcEnabled: enabled ? 1 : 0,
      columnBookSrcJs: js,
      columnBookSrcSHA: sha
    };
    if (sha != null) {
      map[columnBookSrcSHA] = sha;
    }
    return map;
  }

  Future<List<BookInfo>> search(String text) async {
    String res = await run.search(js, text);
    Map<String, dynamic> map = json.decode(res);
    List<BookInfo> books = [];
    if (map['success']) {
      for (var item in map['data']['books']) {
        var bookInfo = BookInfo();
        bookInfo.name = item['name'];
        bookInfo.srcId = name;
        bookInfo.srcsUrl[sha] = item['bookUrl'];
        bookInfo.author = item['author'];
        bookInfo.urlCover = item['coverUrl'];
        bookInfo.introduction = item['introduction'];
        books.add(bookInfo);
      }
    }
    return books;
  }

  Future<String> getContent(String url) async {
    Map<String, dynamic> map = json.decode(await run.getContent(js, url));
    String content = '';
    if (map['success']) {
      content = map['data']['content'];
    }
    return content;
  }

  Future<List<Chapter>> getChapters(String url) async {
    Map<String, dynamic> map = json.decode(await run.getChapters(js, url));
    List<Chapter> chapters = [];
    if (map['success']) {
      for (var item in map['data']['chapters']) {
        var chapter = Chapter(
            index: item['index'],
            url: item['url'],
            name: item['name'],
            content: item['content']);
        chapters.add(chapter);
      }
    }
    return chapters;
  }
}
