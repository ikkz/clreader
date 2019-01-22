import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:clreader/constents.dart';
import 'package:clreader/models/main_model.dart';

void main() => runApp(ClReader());

class ClReader extends StatefulWidget {
  @override
  ClReaderState createState() {
    return ClReaderState();
  }
}

class ClReaderState extends State<ClReader> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ClMainModel>(
        model: ClMainModel.instance,
        child: FutureBuilder(
          future: ClMainModel.of(context).isNightMode,
          builder: (context, ssIsNightMode) {
            if (ssIsNightMode.connectionState == ConnectionState.done) {
              return FutureBuilder(
                  future: ClMainModel.of(context).themeName,
                  builder: (context, ssThemeName) {
                    if (ssThemeName.connectionState == ConnectionState.done) {
                      return MaterialApp(
                          title: Strings.applicationName,
                          theme: ssIsNightMode.data
                              ? ThemeData.dark()
                              : ThemeData(
                                  primarySwatch:
                                      materialColorInfo[ssThemeName.data]),
                          home: Center(
                            child: Icon(Icons.wifi),
                          ));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
