import 'dart:async';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'package:clreader/book/book_src.dart';
import 'package:clreader/book/book_info.dart';
import 'package:clreader/book/chapter.dart';
import 'package:clreader/platform/gbk_urlencode.dart';

class Snwx8 extends BookSrc {
  Snwx8() {
    name = "少年文学";
    id = "9ded08a7737c4e2d8cce72a261d5e2af";
  }

  @override
  Future<List<BookInfo>> search({String name, String author}) async {
    final key = await gbk_urlencode(name ?? author);
    final respose = await http
        .get("https://www.snwx8.com/modules/article/search.php?searchkey=$key");
    final document = parse(respose.body);
    final ul = document.querySelector("#newscontent > div.l > ul");
    List<BookInfo> bookList = [];
    if (ul != null) {
      var li = ul.firstChild;
      while (li != null) {
        
      }
    }
  }

  @override
  Future<List<Chapter>> getChapters(String bookUrl) async {
    return null;
  }

  @override
  Future<String> getContent(String contentUrl) async {
    return null;
  }
}
