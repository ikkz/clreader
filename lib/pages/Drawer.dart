import 'package:flutter/material.dart';
import '../constents.dart';

class ClDrawer extends StatefulWidget {
  @override
  _ClDrawerState createState() {
    return new _ClDrawerState();
  }
}

class _ClDrawerState extends State<ClDrawer> {
  bool isDarkTheme = true;
  @override
  Widget build(BuildContext context) {
    Divider divider = Divider(
      color: Colors.grey,
      height: 10.0,
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
          ListTile(
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
            leading: Icon(Icons.color_lens),
            title: Text("夜间模式"),
            trailing: Switch(
              value: isDarkTheme,
              onChanged: (bool value) {
                setState(() {
                  isDarkTheme = value;
                });
              },
            ),
          ),
          divider,
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("救助作者"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("关于"),
            onTap: () {
              showAboutDialog(
                  context: context,
                  applicationName: applicationName,
                  applicationVersion: applicationVersion,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[Text("Author: cildhdi")],
                      ),
                    )
                  ].toList());
            },
          )
        ],
      ),
    ));
  }
}
