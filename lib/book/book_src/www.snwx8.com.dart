import 'dart:async';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';

import 'package:clreader/util.dart' as util;
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
      {String name, String author, int searchId, BookCallback callback}) async {
    final key = await gbk_urlencode(name ?? author);
    final respose = await http
        .get("https://www.snwx8.com/modules/article/search.php?searchkey=$key");
    final document = parse(respose.body);
    var li = document.querySelector("#newscontent > div.l > ul > li");

    while (li != null) {
      BookInfo info = BookInfo();
      final s2a = li.querySelector("span.s2 > a");
      info.name = decodeGbk(s2a.text.codeUnits);
      info.srcId = this.id;
      info.srcsUrl[this.id] = s2a.attributes["href"];

      final s4a = li.querySelector("span.s4 > a");
      info.author = decodeGbk(s4a.text.codeUnits);

      final pageRes = await http.get(info.srcsUrl[this.id]);
      if (pageRes != null) {
        final pageDoc = parse(pageRes.body);
        final img = pageDoc.querySelector("#fmimg > img");
        //"https://www.snwx8.com/modules/article/images/nocover.jpg"
        info.urlCover = img.attributes["src"];
        final imgResp = await http.get(info.urlCover);
        if (imgResp.statusCode == 404) {
          info.urlCover =
              "https://www.snwx8.com/modules/article/images/nocover.jpg";
        }
        final intro = pageDoc.querySelector("#info > div.intro");
        info.introduction =
            util.removeHtmlTag(decodeGbk(intro.innerHtml.codeUnits));
        info.introduction = info.introduction
            .substring(info.introduction.indexOf(RegExp("简介")) + 3);
      }
      if (callback != null) {
        if (!callback(info, searchId)) {
          return;
        }
      }
      li = li.nextElementSibling;
    }
  }

  @override
  Future<List<Chapter>> getChapters(String bookUrl) async {
    List<Chapter> chapters = [];

    final doc = parse((await http.get(bookUrl)).body);
    final url = doc.querySelector("#fmimg > p > a").attributes["href"];
    final response = await http.get("https://www.snwx8.com${url}");
    final document = parse(response.body);
    var li = document.querySelector("#Chapters > ul > li");
    int index = 1;
    while (li != null) {
      Chapter chapter = Chapter();
      final a = parse(li.innerHtml).querySelector("a");
      chapter.index = index++;
      chapter.url = a.attributes["href"];
      chapter.name = decodeGbk(a.text.codeUnits);
      chapter.content = "";
      chapters.add(chapter);
      li = li.nextElementSibling;
    }
    return chapters;
  }

  @override
  Future<String> getContent(String contentUrl) async {
    try {
      final doc = parse((await http.get(contentUrl)).body);
      final content = doc.querySelector("#BookText");
      return util
          .removeNbsp(util.removeHtmlTag(decodeGbk(content.text.codeUnits)))
          .replaceAll(RegExp("牋"), "");
    } catch (e) {
      return "";
    }
  }
}
