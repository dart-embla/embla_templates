import 'dart:async';
import 'package:shelf/shelf.dart';
import 'dart:io';
import 'dart:convert';

abstract class ViewEngine {
  final Encoding encoding;
  final Iterable<String> extensions;

  ViewEngine(this.extensions, this.encoding);

  Template render(Stream<String> lines, {int statusCode: 200});
}

class Template implements Future<Response> {
  final int statusCode;
  final Stream<String> lines;
  final ContentType contentType;
  final Encoding encoding;

  Template(this.statusCode, this.lines,
      this.contentType, {this.encoding: UTF8});

  Future<Response> _cache;
  Future<Response> get _future => _cache ??= _makeFuture();
  Future<Response> _makeFuture() async {
    return new Response(
      statusCode,
      body: lines.map(encoding.encode),
      encoding: encoding,
      headers: {
        'Content-Type': contentType.toString()
      });
  }

  @override
  Future then(onValue(Response value), {Function onError}) {
    return _future.then(onValue, onError: onError);
  }

  @override
  Stream<Response> asStream() {
    return _future.asStream();
  }

  @override
  Future catchError(Function onError, {bool test(Object error)}) {
    return _future.catchError(onError, test: test);
  }

  @override
  Future timeout(Duration timeLimit, {onTimeout()}) {
    return _future.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<Response> whenComplete(action()) {
    return _future.whenComplete(action);
  }
}
