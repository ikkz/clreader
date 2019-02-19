import 'package:flutter/material.dart';
import 'dart:async';

import 'text_edit_dialog.dart';

class SimpleDialogs {
  static void alert(
      {@required BuildContext context,
      String title,
      @required String content}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title != null ? Text(title) : null,
            content: Text(
              content,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Theme.of(context).textTheme.caption.color),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text("确认"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  static Future<String> edit_text(
      {@required BuildContext context,
      @required String title,
      @required String defaultText}) {
    return showDialog<String>(
        context: context,
        builder: (context) {
          return TextEditDiaglog(
            title: title,
            defaultText: defaultText,
          );
        });
  }
}
