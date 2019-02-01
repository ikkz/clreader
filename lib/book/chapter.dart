final String columnChapterId = "_id";
final String columnChapterIndex = "_index";
final String columnChapterName = "name";
final String columnChapterUrl = "url";
final String columnChapterContent = "content";

class Chapter {
  int id;
  int index;
  String name = "";
  String url = "";
  String content = "";

  Chapter({this.id, this.index, this.name, this.url, this.content});

  Chapter.formMap(Map<String, dynamic> map)
      : id = map[columnChapterId],
        index = map[columnChapterIndex],
        name = map[columnChapterName],
        url = map[columnChapterUrl],
        content = map[columnChapterContent];

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnChapterIndex: index,
      columnChapterName: name,
      columnChapterUrl: url,
      columnChapterContent: content
    };
    if (id != null) {
      map[columnChapterId] = id;
    }
    return map;
  }
}
