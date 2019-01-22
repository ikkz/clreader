import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:clreader/models/main_model.dart';
import 'package:clreader/constents.dart';
import 'package:clreader/pages/help_author_page.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainModel = ClMainModel.of(context);
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
          FutureBuilder(
            future: mainModel.isNightMode,
            builder: (context, ssIsNightMode) {
              if (ssIsNightMode.connectionState == ConnectionState.done) {
                return ListTile(
                  leading: Icon(Icons.wb_sunny),
                  title: Text("夜间模式"),
                  trailing: Switch(
                    value: ssIsNightMode.data,
                    onChanged: (bool value) {
                      mainModel.setNightMode(value);
                    },
                  ),
                  onTap: () {
                    mainModel.setNightMode(!ssIsNightMode.data);
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          FutureBuilder(
              future: mainModel.isNightMode,
              builder: (context, ssIsNightMode) {
                if (ssIsNightMode.connectionState == ConnectionState.done) {
                  return Offstage(
                    offstage: ssIsNightMode.data,
                    child: ListTile(
                      leading: Icon(Icons.color_lens),
                      title: Text("修改主题色"),
                      trailing: Padding(
                        child: FutureBuilder(
                          future: mainModel.themeName,
                          builder: (context, ssThemeName) {
                            if (ssThemeName.connectionState ==
                                ConnectionState.done) {
                              return CircleAvatar(
                                backgroundColor:
                                    materialColorInfo[ssThemeName.data],
                                radius: 13,
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                        padding: EdgeInsets.only(right: 10),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              var themeColors = new List<Widget>();
                              materialColorInfo.forEach(
                                  (String colorName, MaterialColor color) {
                                themeColors.add(SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      mainModel.setThemeName(colorName);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          "请选择主题色",
                                          style:
                                              Theme.of(context).textTheme.title,
                                        ),
                                      ),
                                      divider
                                    ],
                                  ),
                                  children: themeColors);
                            });
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          divider,
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("救助作者"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HelpAuthorPage();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.bug_report),
            title: Text("书源/Bug反馈"),
            onTap: () {
              launch(Strings.applicationUrl);
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
                  applicationName: Strings.applicationName,
                  applicationVersion: Strings.applicationVersion,
                  children: <Widget>[Text("Author: cildhdi")]);
            },
          )
        ],
      ),
    ));
  }
}
