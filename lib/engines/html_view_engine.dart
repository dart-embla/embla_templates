import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';

class HtmlViewEngine extends ViewEngine {
  HtmlViewEngine() : super(['.htm', '.html', '.html5', '.xhtml']);

  render(
      Stream<String> lines,
      Template template,
      void writeLine(String line),
      void setContentType(ContentType contentType)
  ) {
    setContentType(ContentType.TEXT);
    lines.listen(writeLine);
  }
}