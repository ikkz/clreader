class BookSrc {
  final String name;

  BookSrc({this.name});

  int get id => "$name".hashCode;
}
