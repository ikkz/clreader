import 'dart:convert';

final String tableBookShelves = "bookShelves";
final String columnBookShelfId = "_id";
final String columnBookShelfName = "name";
final String columnBookShelfBookIds = "bookIds";

class BookShelf {
  int id;
  String name;
  List<int> bookIds;
  BookShelf.fromMap(Map<String, dynamic> map)
      : id = map[columnBookShelfId],
        name = map[columnBookShelfName],
        bookIds = json.decode(map[columnBookShelfBookIds]);

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
