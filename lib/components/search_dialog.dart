import 'package:flutter/material.dart';

class SearchDialog extends StatefulWidget {
  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  bool _name = true;
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleValueChange(bool value) {
    setState(() {
      _name = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("搜索"),
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            autofocus: true,
            controller: _controller,
          ),
          Row(
            children: <Widget>[
              Radio<bool>(
                groupValue: _name,
                value: true,
                onChanged: _handleValueChange,
              ),
              Text("书名"),
              Radio<bool>(
                groupValue: _name,
                value: false,
                onChanged: _handleValueChange,
              ),
              Text("作者"),
            ],
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("搜索"),
          onPressed: () {
            Navigator.of(context)
                .pop({"searchText": _controller.text, "name": _name});
          },
        )
      ],
    );
  }
}
