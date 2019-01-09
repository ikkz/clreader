import 'package:flutter/material.dart';
import '../Config.dart';

class ClDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        Container(
          height: 200.0,
          color: Theme.of(context).primaryColor,
        ),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
                leading: Icon(Icons.attach_money),
                title: Text("救助作者"),
                onTap: () {
                },
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
        )
      ],
    ));
  }
}
