import 'package:flutter/material.dart';
import 'package:clipboard_manager/clipboard_manager.dart';

import 'package:clreader/constents.dart';

class HelpAuthorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("救助作者"),
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "方法一（推荐）：",
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Image.asset("assets/pics/alipay.jpg"),
                  ),
                  ListTile(
                    title: Text(
                      "方法二：带作者上分",
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                      "点击复制王者荣耀id:${Strings.wzryId}",
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    onTap: () {
                      ClipboardManager.copyToClipBoard(Strings.wzryId)
                          .then((result) {
                        final snackBar = SnackBar(
                          content: Text("已复制到剪贴板"),
                        );
                        Scaffold.of(context).showSnackBar(snackBar);
                      });
                    },
                  )
                ],
              ),
            ));
          },
        ));
  }
}
