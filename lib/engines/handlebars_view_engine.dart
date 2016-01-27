import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';
import 'package:mustache/mustache.dart' as mustache;

class HandlebarsViewEngine extends ViewEngine {
  HandlebarsViewEngine() : super(['.hbs', '.handlebars', '.mustache']);

  Future render(
      Stream<String> lines,
      Template template,
      void writeLine(String line),
      void setContentType(ContentType contentType)
  ) async {
    setContentType(ContentType.HTML);
    final source = await lines.join('\n');
    new mustache.Template(source)
        .renderString(template.locals)
        .split('\n')
        .forEach(writeLine);
  }
}
