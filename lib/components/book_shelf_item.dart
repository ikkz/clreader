import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:clreader/book/book_shelf.dart';

class BookShelfItem extends StatelessWidget {
  final BookShelf bookShelf;
  final bool selected;
  final ValueChanged<bool> onCheckboxChanged;
  final VoidCallback onEdit;

  BookShelfItem(
      {Key key,
      @required this.bookShelf,
      @required this.selected,
      @required this.onCheckboxChanged,
      @required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: selected,
        onChanged: onCheckboxChanged,
      ),
      title: Text(
        "${bookShelf.name} (${bookShelf.bookIds.length})",
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: onEdit,
      ),
    );
  }
}
