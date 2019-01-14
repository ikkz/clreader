import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:clreader/main.dart';
import 'package:clreader/constents.dart';
import 'package:clreader/pages/help_author.dart';

class ClDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ClReaderState state = ClReaderStateShare.of(context).state;
    Divider divider = Divider(
      height: 1,
      color: Colors.grey,
    );
    return Drawer(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CircleAvatar(
                  child: Text(
                    "Cl",
                    style: Theme.of(context).primaryTextTheme.title.merge(
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 30)),
                  ),
                  radius: 30.0,
                ),
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            leading: Icon(Icons.list),
            title: Text("书架管理"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text("搜索设置"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.wb_sunny),
            title: Text("夜间模式"),
            trailing: Switch(
              value: state.isNightMode,
              onChanged: (bool value) {
                state.setNightMode(value);
              },
            ),
            onTap: () {
              state.setNightMode(!state.isNightMode);
            },
          ),
          Offstage(
            offstage: state.isNightMode,
            child: ListTile(
              leading: Icon(Icons.color_lens),
              title: Text("修改主题色"),
              trailing: Padding(
                child: CircleAvatar(
                  backgroundColor: materialColorInfo[state.themeName],
                  radius: 13,
                ),
                padding: EdgeInsets.only(right: 10),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      var themeColors = new List<Widget>();
                      materialColorInfo
                          .forEach((String colorName, MaterialColor color) {
                        themeColors.add(SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context);
                              state.setThemeName(colorName);
                            },
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              title: Text(colorName),
                              trailing: CircleAvatar(
                                backgroundColor: color,
                                radius: 15,
                              ),
                            )));
                      });
                      return SimpleDialog(
                          titlePadding: EdgeInsets.all(0),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "请选择主题色",
                                  style: Theme.of(context).textTheme.title,
                                ),
                              ),
                              divider
                            ],
                          ),
                          children: themeColors);
                    });
              },
            ),
          ),
          divider,
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("救助作者"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HelpAuthor();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.bug_report),
            title: Text("书源/Bug反馈"),
            onTap: () {
              launch(applicationUrl);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("关于"),
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationIcon: CircleAvatar(
                      child: Text(
                    "Cl",
                    style: Theme.of(context).primaryTextTheme.title.merge(
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 30)),
                  )),
                  applicationName: applicationName,
                  applicationVersion: applicationVersion,
                  children: <Widget>[Text("Author: cildhdi")].toList());
            },
          )
        ],
      ),
    ));
  }
}
