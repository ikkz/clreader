import 'dart:async';

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
    print(await run.search(js, text));
    return [];
  }

  Future<String> getContent(String url) async {
    print(await run.getContent(js, url));
    return "";
  }

  Future<List<Chapter>> getChapters(String url) async {
    print(await run.getChapters(js, url));
    return [];
  }
}
