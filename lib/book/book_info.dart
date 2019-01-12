class BookInfo {
  String urlCover = "";
  String name = "";
  String author = "";
  String introduction = "";
  int srcId;

  BookInfo(
      {this.urlCover, this.name, this.author, this.introduction, this.srcId});

  BookInfo.fromJson(Map<String, dynamic> json)
      : urlCover = json["urlCover"],
        name = json["name"],
        author = json["author"],
        introduction = json["introduction"],
        srcId = json["srcId"];

  Map<String, dynamic> toJson() => <String, dynamic>{
        "urlCover": urlCover,
        "name": name,
        "author": author,
        "introduction": introduction,
        "srcId": srcId,
      };

  int get id => "$name$author$srcId".hashCode;
}
