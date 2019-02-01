String removeHtmlTag(String str) {
  return str.replaceAll(RegExp("<[^>]+>"), "");
}

String removeNbsp(String str) {
  return str.replaceAll(RegExp("&nbsp;"), " ");
}
