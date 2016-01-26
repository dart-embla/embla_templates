import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class JsonViewEngine extends ViewEngine {
  JsonViewEngine(Encoding encoding) : super([
    '.json'
  ], encoding);

  Template render(Stream<String> lines, {int statusCode: 200}) {
    return new Template(
        statusCode,
        lines,
        ContentType.JSON,
        encoding: encoding
    );
  }
}