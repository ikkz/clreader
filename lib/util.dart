String removeHtmlTag(String str) {
  str = str.replaceAll(RegExp("<br>"), "\n");
  str = str.replaceAll(RegExp("&nbsp;"), " ");
  return str.replaceAll(RegExp("<[^>]+>"), "");
}
