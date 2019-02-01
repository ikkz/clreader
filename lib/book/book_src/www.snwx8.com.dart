import 'dart:async';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';

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
  Future<void> search(
      {String name, String author, BookCallback callback}) async {
    final key = await gbk_urlencode(name ?? author);
    final respose = await http
        .get("https://www.snwx8.com/modules/article/search.php?searchkey=$key");
    final document = parse(respose.body);
    var li = document.querySelector("#newscontent > div.l > ul > li");

    while (li != null) {
      BookInfo info = BookInfo();
      final s2a = li.querySelector("span.s2 > a");
      info.name = decodeGbk(s2a.text.codeUnits);
      info.srcsUrl[this.id] = s2a.attributes["href"];

      final s4a = li.querySelector("span.s4 > a");
      info.author = decodeGbk(s4a.text.codeUnits);

      final pageRes = await http.get(info.srcsUrl[this.id]);
      if (pageRes != null) {
        final pageDoc = parse(pageRes.body);
        final img = pageDoc.querySelector("#fmimg > img");
        info.urlCover =
            img.attributes["src"] == "/modules/article/images/nocover.jpg"
                ? "https://www.snwx8.com/modules/article/images/nocover.jpg"
                : img.attributes["src"];
        final intro = pageDoc.querySelector("#info > div.intro");
        info.introduction = decodeGbk(intro.innerHtml.codeUnits)
            .replaceAll(RegExp("<[^>]+>"), "");
        info.introduction = info.introduction
            .substring(info.introduction.indexOf(RegExp("简介")) + 3);
      }
      if (callback != null) {
        callback(info);
      }
      li = li.nextElementSibling;
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
