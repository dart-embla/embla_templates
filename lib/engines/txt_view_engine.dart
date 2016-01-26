import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';

class TxtViewEngine extends ViewEngine {
  TxtViewEngine() : super(['.txt']);

  Future render(
      Stream<String> lines,
      Template template,
      void writeLine(String line),
      void setContentType(ContentType contentType)
  ) async {
    setContentType(ContentType.TEXT);
    await lines.listen(writeLine).asFuture();
  }
}