import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:clreader/book/book_src.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/components/simple_dialogs.dart';

class BookSrcMgrPage extends StatefulWidget {
  @override
  _BookSrcMgrPageState createState() => _BookSrcMgrPageState();
}

enum MenuItemType { UPDATE, CHANGE_SRC_REPO }

class _BookSrcMgrPageState extends State<BookSrcMgrPage> {
  List<BookSrc> _srcs;

  void _checkUpdate(BuildContext context) async {
    Scaffold.of(context).showSnackBar(SnackBar(
        content: const Text('开始检查更新'), duration: Duration(seconds: 1)));
    final mainModel = ClMainModel.of(context);
    final response = await http
        .get("https://api.github.com/repos/${mainModel.srcRepo}/contents");
    if (response.statusCode == 200) {
      if (_srcs != null) {
        for (var src in _srcs) {
          mainModel.deleteBookSrc(src.sha);
        }
      }
      List<dynamic> newSrcs = json.decode(response.body);
      int updateCount = 0;
      newSrcs.forEach((map) async {
        if (map['name'].endsWith('.js')) {
          final String name = map['name'];
          try {
            final jr = await http.get(map['download_url']);
            if (jr.statusCode == 200) {
              var src = BookSrc(
                  name: name.substring(0, name.length - 3),
                  enabled: true,
                  sha: map['sha'],
                  js: jr.body);
              mainModel.insertBookSrc(src);
            }
          } catch (e) {
            Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('更新 ${name} 失败'),
                duration: Duration(seconds: 1)));
          }
        }
        updateCount++;
        if (updateCount == newSrcs.length) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: const Text('更新成功')));
          this.setState(() {
            _srcs = null;
          });
        }
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: const Text('更新失败')));
    }
  }

  void _changeSrcRepo(BuildContext context) async {
    final mainModel = ClMainModel.of(context);
    final repo = await SimpleDialogs.edit_text(
        context: context, title: "按以下格式输入仓库名", defaultText: "cildhdi/clsrc");
    if (repo != null && repo.length != 0) {
      mainModel.setSrcRepo(repo);
      mainModel.notifyListeners();
    }
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) {
        return ListTile(
          leading: Checkbox(value: _srcs[i].enabled),
          title: Text(_srcs[i].name),
        );
      },
      itemCount: _srcs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("阅读源管理"),
        actions: <Widget>[
          Builder(builder: (context) {
            return PopupMenuButton<MenuItemType>(
              itemBuilder: (context) {
                return <PopupMenuEntry<MenuItemType>>[
                  PopupMenuItem<MenuItemType>(
                    value: MenuItemType.UPDATE,
                    child: Text("更新"),
                  ),
                  PopupMenuItem<MenuItemType>(
                    value: MenuItemType.CHANGE_SRC_REPO,
                    child: Text("修改阅读源仓库"),
                  )
                ];
              },
              onSelected: (type) {
                switch (type) {
                  case MenuItemType.UPDATE:
                    _checkUpdate(context);
                    break;
                  case MenuItemType.CHANGE_SRC_REPO:
                    _changeSrcRepo(context);
                    break;
                  default:
                }
              },
            );
          })
        ],
      ),
      body: _srcs == null
          ? FutureBuilder(
              future: ClMainModel.of(context).getBookSrcs(),
              builder: (context, AsyncSnapshot<List<BookSrc>> ssBookSrcs) {
                if (ssBookSrcs.connectionState == ConnectionState.done) {
                  _srcs = ssBookSrcs.data;
                  return _buildList(context);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : _buildList(context),
    );
  }
}
