import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:clreader/constents.dart';
import 'package:clreader/models/main_model.dart';
import 'package:clreader/pages/book_shelf_page.dart';

void main() => runApp(ClReader());

class ClReader extends StatefulWidget {
  @override
  ClReaderState createState() {
    return ClReaderState();
  }
}

class ClReaderState extends State<ClReader> {
  Widget _defaultHome(BuildContext context) {
    return MaterialApp(
        title: Strings.applicationName,
        theme: ThemeData.light(),
        home: Center(
          child: CircularProgressIndicator(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ClMainModel.instance,
      builder: (context, AsyncSnapshot<ClMainModel> ssModel) {
        if (ssModel.connectionState == ConnectionState.done) {
          return ScopedModel<ClMainModel>(
              model: ssModel.data,
              child: ScopedModelDescendant<ClMainModel>(
                builder: (context, child, model) {
                  return MaterialApp(
                      title: Strings.applicationName,
                      theme: model.isNightMode
                          ? ThemeData.dark()
                          : ThemeData(
                              primarySwatch:
                                  materialColorInfo[model.themeName]),
                      home: BookShelfPage());
                },
              ));
        } else {
          return _defaultHome(context);
        }
      },
    );
  }
}
