import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';

class HtmlViewEngine extends ViewEngine {
  HtmlViewEngine() : super(['.htm', '.html', '.html5', '.xhtml']);

  Future render(
      Stream<String> lines,
      Template template,
      void writeLine(String line),
      void setContentType(ContentType contentType)
      ) async {
    setContentType(ContentType.HTML);
    await lines.listen(writeLine).asFuture();
  }
}