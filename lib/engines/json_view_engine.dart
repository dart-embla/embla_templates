import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';

class JsonViewEngine extends ViewEngine {
  JsonViewEngine() : super(['.json']);

  render(
      Stream<String> lines,
      Template template,
      void writeLine(String line),
      void setContentType(ContentType contentType)
  ) {
    setContentType(ContentType.JSON);
    lines.listen(writeLine);
  }
}