import 'dart:async';

import 'package:clreader/platform/channel.dart';

Future<String> search(String src, String name) async {
  return await channel.invokeMethod('search', {"js": src, "str": name});
}

Future<String> getChapters(String src, String url) async {
  return await channel.invokeMethod('getChapters', {"js": src, "str": url});
}

Future<String> getContent(String src, String url) async {
  return await channel.invokeMethod('getContent', {"js": src, "str": url});
}
