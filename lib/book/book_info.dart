import 'package:meta/meta.dart';
import 'dart:convert';

final String tableBooks = "books";
final String columnBookId = "_id";
final String columnBookName = "name";
final String columnBookAuthor = "author";
final String columnBookCoverUrl = "urlCover";
final String columnBookIntroduction = "introduction";
final String cloumnBookSrc = "srcId";
final String columnBookSrcsUrl = "srcsUrl";

class BookInfo {
  int id;
  String srcId;
  String urlCover = "";
  String name = "";
  String author = "";
  String introduction = "";
  Map<String, String> srcsUrl = {};

  BookInfo(
      {this.id,
      @required this.urlCover,
      @required this.name,
      @required this.author,
      @required this.introduction,
      @required this.srcId});

  BookInfo.fromMap(Map<String, dynamic> map)
      : urlCover = map[columnBookCoverUrl],
        name = map[columnBookName],
        author = map[columnBookAuthor],
        introduction = map[columnBookIntroduction],
        srcId = map[cloumnBookSrc],
        id = map[columnBookId] {
    final su = json.decode(map[columnBookSrcsUrl]);
    su.forEach((key, value) {
      srcsUrl[key] = value;
    });
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnBookCoverUrl: urlCover,
      columnBookName: name,
      columnBookAuthor: author,
      columnBookIntroduction: introduction,
      cloumnBookSrc: srcId,
      columnBookSrcsUrl: json.encode(srcsUrl)
    };
    if (id != null) {
      map[columnBookId] = id;
    }
    return map;
  }
}
