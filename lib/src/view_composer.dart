import 'view_engine.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

abstract class TemplateLoader {
  Stream<String> load(String filename);
  Future<bool> exists(String filename);
}

class IoTemplateLoader extends TemplateLoader {
  final String templateDirectory;
  final Encoding encoding;

  IoTemplateLoader(this.templateDirectory, this.encoding);

  File file(String filename) => new File(path.join(templateDirectory, filename));

  Stream<String> load(String filename) {
    return file(filename).openRead().map(encoding.decode);
  }

  Future<bool> exists(String filename) {
    return file(filename).exists();
  }
}

class TemplateNotFoundException implements Exception {
  final String filename;

  TemplateNotFoundException(this.filename);

  String toString() => 'TemplateNotFoundException: '
      'Could not find "$filename". Did you forget to register '
      'the correct ViewEngine?';
}

class ViewComposer {
  final List<ViewEngine> engines;
  final TemplateLoader _loader;

  ViewComposer(this._loader, this.engines);

  factory ViewComposer.create({
  List<ViewEngine> engines: const [],
  String templatesDirectory: 'web', Encoding encoding: UTF8
  }) {
    return new ViewComposer(new IoTemplateLoader(templatesDirectory, encoding), engines);
  }

  Template render(String template) async {
    for (final engine in engines) {
      for (final extension in engine.extensions) {
        final path = template + extension;
        if (await _loader.exists(path)) {
          return engine.render(_loader.load(path));
        }
      }
    }
    throw new TemplateNotFoundException(template);
  }
}