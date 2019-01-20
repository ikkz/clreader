import 'package:meta/meta.dart';

final String tableBooks = "books";
final String columnBookId = "_id";
final String columnBookName = "name";
final String columnBookAuthor = "author";
final String columnBookCoverUrl = "urlCover";
final String columnBookIntroduction = "introduction";
final String cloumnBookSrc = "srcId";

class BookInfo {
  int id;
  int srcId;
  String urlCover = "";
  String name = "";
  String author = "";
  String introduction = "";

  BookInfo(
      {@required this.urlCover,
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
        id = map[columnBookId];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnBookCoverUrl: urlCover,
      columnBookName: name,
      columnBookAuthor: author,
      columnBookIntroduction: introduction,
      cloumnBookSrc: srcId
    };
    if (id != null) {
      map[columnBookId] = id;
    }
    return map;
  }
}
