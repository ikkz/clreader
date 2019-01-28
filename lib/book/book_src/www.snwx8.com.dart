import 'dart:async';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'dart:convert';

import 'package:clreader/book/book_src.dart';
import 'package:clreader/book/book_info.dart';
import 'package:clreader/book/chapter.dart';

class Snwx8 extends BookSrc {
  Dio dio;

  Snwx8() {
    name = "少年文学";
    id = "9ded08a7737c4e2d8cce72a261d5e2af";

    dio = new Dio();
    dio.options.baseUrl = "https://www.snwx8.com";
    dio.options.connectTimeout = 8000;
    dio.options.receiveTimeout = 3000;
  }

  @override
  Future<List<BookInfo>> search({String name, String author}) async {
    final String p = name ?? author;
    var u8 = latin1.encode(p);
    String key = "";
    for (var i in u8) {
      key += ('%' + i.toRadixString(16));
    }
    print(key);
    final respose =
        await dio.get("/modules/article/search.php", data: {"searchkey": key});
    final document = parse(respose.data.toString());
    final ele = document.querySelector("#newscontent");
    print(ele.innerHtml);
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
