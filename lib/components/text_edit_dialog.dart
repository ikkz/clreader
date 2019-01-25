import 'package:flutter/material.dart';

class TextEditDiaglog extends StatefulWidget {
  final String title;
  final String defaultText;

  TextEditDiaglog({@required this.defaultText, @required this.title});
  @override
  _TextEditDiaglogState createState() => _TextEditDiaglogState();
}

class _TextEditDiaglogState extends State<TextEditDiaglog> {
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.defaultText;
    _textEditingController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _textEditingController.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      contentPadding: EdgeInsets.all(16.0),
      children: <Widget>[
        TextField(
          autofocus: true,
          controller: _textEditingController,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text("确定"),
                onPressed: () {
                  Navigator.of(context)
                      .pop<String>(_textEditingController.text);
                }),
          ],
        )
      ],
    );
  }
}
