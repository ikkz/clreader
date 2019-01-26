import 'package:flutter/material.dart';
import 'dart:async';

import 'text_edit_dialog.dart';

class SimpleDialogs {
  static void alert(
      {@required BuildContext context,
      @required String title,
      @required String content}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            contentPadding: EdgeInsets.all(30),
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
