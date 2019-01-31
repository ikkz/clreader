import 'dart:async';

import 'package:clreader/platform/channel.dart';

Future<String> gbk_urlencode(String str) async {
  return await channel.invokeMethod<String>('gbk_urlencode', str);
}
