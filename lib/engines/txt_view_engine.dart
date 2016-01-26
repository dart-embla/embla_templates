import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class TxtViewEngine extends ViewEngine {
  TxtViewEngine(Encoding encoding) : super([
    '.txt'
  ], encoding);

  Template render(Stream<String> lines, {int statusCode: 200}) {
    return new Template(
        statusCode,
        lines,
        ContentType.TEXT,
        encoding: encoding
    );
  }
}