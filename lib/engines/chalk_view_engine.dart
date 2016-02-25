import '../src/view_engine.dart';
import 'dart:async';
import 'dart:io';

class ChalkViewEngine extends ViewEngine {
  ChalkViewEngine() : super(['.chalk', '.chalk.html']);

  Future render(
      Stream<String> lines,
      Template template,
      void writeLine(String line),
      void setContentType(ContentType contentType)
  ) async {
    setContentType(ContentType.HTML);
    throw new UnimplementedError('TBD');
  }
}
