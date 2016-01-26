import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:mustache/mustache.dart' as mustache;

class HandlebarsViewEngine extends ViewEngine {
  HandlebarsViewEngine(Encoding encoding) : super([
    '.hbs', '.handlebars', '.mustache'
  ], encoding);

  Template render(Stream<String> lines, {int statusCode: 200}) async {
    StreamController controller;
    controller = new StreamController(onListen: () async {
      final source = await lines.join('\n');
      final template = new mustache.Template(source);
      await controller.addStream(new Stream<String>.fromIterable(template.renderString({}).split('\n')));
      await controller.close();
    });
    return new Template(
        statusCode,
        controller.stream,
        ContentType.HTML,
        encoding: encoding
    );
  }
}
//
//class StreamControllerSinkAdapter implements StreamController<String>, StringSink {
//  final StreamController<String> _controller = new StreamController<String>();
//
//  ControllerCancelCallback get onCancel => _controller.onCancel;
//
//  ControllerCallback get onListen => _controller.onListen;
//
//  ControllerCallback get onPause => _controller.onPause;
//
//  ControllerCallback get onResume => _controller.onResume;
//
//  void set onCancel(onCancelHandler()) {
//    _controller.onCancel = onCancelHandler;
//  }
//
//  void set onListen(void onListenHandler()) {
//    _controller.onListen = onListenHandler;
//  }
//
//  void set onPause(void onPauseHandler()) {
//    _controller.onPause = onPauseHandler;
//  }
//
//  void set onResume(void onResumeHandler()) {
//    _controller.onResume = onResumeHandler;
//  }
//
//  void add(String event) => _controller.add(event);
//
//  void addError(Object error, [StackTrace stackTrace]) =>
//      _controller.addError(error, stackTrace);
//
//  Future addStream(Stream<String> source, {bool cancelOnError: true}) =>
//      _controller.addStream(source, cancelOnError: cancelOnError);
//
//  Future close() => _controller.close();
//
//  Future get done => _controller.done;
//
//  bool get hasListener => _controller.hasListener;
//
//  bool get isClosed => _controller.isClosed;
//
//  bool get isPaused => _controller.isPaused;
//
//  StreamSink<String> get sink => _controller;
//
//  Stream<String> get stream => _controller.stream;
//
//  void write(Object obj) => _controller.add('$obj');
//
//  void writeAll(Iterable objects, [String separator = ""]) => _controller.add(objects.join(separator));
//
//  void writeCharCode(int charCode) => _controller.add(new String.fromCharCode(charCode));
//
//  void writeln([Object obj = ""]) => _controller.add('$obj\n');
//}
