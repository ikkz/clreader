import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:clreader/book/book_shelf.dart';

class BookShelfItem extends StatefulWidget {
  BookShelf bookShelf;
  bool selected;
  ValueChanged<bool> onCheckboxChanged;
  VoidCallback onEdit;
  VoidCallback onDelete;

  BookShelfItem(
      {@required this.bookShelf,
      @required this.selected,
      @required this.onCheckboxChanged,
      @required this.onEdit});

  @override
  _BookShelfItemState createState() => _BookShelfItemState();
}

class _BookShelfItemState extends State<BookShelfItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.selected,
        onChanged: widget.onCheckboxChanged,
      ),
      title: Text(
        "${widget.bookShelf.name} (${widget.bookShelf.bookIds.length})",
      ),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: widget.onEdit,
      ),
    );
  }
}
