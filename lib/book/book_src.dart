import 'package:meta/meta.dart';

class BookSrc {
  final String name;

  BookSrc({@required this.name});

  int get id => "$name".hashCode;
}
