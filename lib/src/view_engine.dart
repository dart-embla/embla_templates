import 'dart:async';
import 'package:shelf/shelf.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:mirrors';

abstract class ViewEngine {
  final Iterable<String> extensions;

  ViewEngine(this.extensions);

  Future render(
      Stream<String> lines,
      Template template,
      void writeLine(String line),
      void setContentType(ContentType contentType)
  );
}

@proxy
class Template implements Future<Response> {
  final String name;
  final int _statusCode;
  final Stream<String> _lines;
  final Future<ContentType> _contentType;
  final Map<String, dynamic> locals = <String, dynamic>{};

  Template(this.name, this._statusCode, this._lines, this._contentType);

  Future<Response> get _future {
    final completer = new Completer<Response>();
    final controller = new StreamController<List<int>>();
    _lines.map(UTF8.encode).listen(controller.add, onDone: () {
      controller.close();
    }, onError: (e, s) {
      if (!completer.isCompleted) {
        completer.completeError(e, s);
        return;
      }
      print('Uncaught error in response stream: $e');
    });
    _contentType.then((contentType) {
      if (completer.isCompleted) {
        return;
      }
      completer.complete(new Response(
        _statusCode,
        body: controller.stream,
        encoding: UTF8,
        headers: {
          'Content-Type': contentType.toString()
        })
      );
    });
    return completer.future;
  }

  noSuchMethod(Invocation invocation) {
    if (invocation.isSetter) {
      final key = MirrorSystem
          .getName(invocation.memberName)
          .replaceFirst('=', '');

      return locals[key] = invocation.positionalArguments[0];
    }
    return super.noSuchMethod(invocation);
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
