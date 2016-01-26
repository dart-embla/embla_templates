import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';

class JsonViewEngine extends ViewEngine {
  JsonViewEngine() : super(['.json']);

  Future render(
      Stream<String> lines,
      Template template,
      void writeLine(String line),
      void setContentType(ContentType contentType)
      ) async {
    setContentType(ContentType.JSON);
    await lines.listen(writeLine).asFuture();
  }
}