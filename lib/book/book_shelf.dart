import 'dart:convert';

final String tableBookShelves = "bookShelves";
final String columnBookShelfId = "_id";
final String columnBookShelfName = "name";
final String columnBookShelfBookIds = "bookIds";

class BookShelf {
  int id;
  String name;
  List<int> bookIds;

  BookShelf({this.name, this.bookIds});

  BookShelf.fromMap(Map<String, dynamic> map) {
    id = map[columnBookShelfId];
    name = map[columnBookShelfName];
    final list = json.decode(map[columnBookShelfBookIds]);
    bookIds = [];
    list.forEach((dynamic i) {
      bookIds.add(i);
    });
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnBookShelfName: name,
      columnBookShelfBookIds: json.encode(bookIds)
    };
    if (id != null) {
      map[columnBookShelfId] = id;
    }
    return map;
  }
}
