import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class HtmlViewEngine extends ViewEngine {
  HtmlViewEngine(Encoding encoding) : super([
    '.htm', '.html', '.html5', '.xhtml'
  ], encoding);

  Template render(Stream<String> lines, {int statusCode: 200}) {
    return new Template(
        statusCode,
        lines,
        ContentType.HTML,
        encoding: encoding
    );
  }
}