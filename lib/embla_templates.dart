import 'dart:convert';
import 'dart:mirrors';

import 'package:embla/application.dart';

import 'src/view_composer.dart';
import 'src/view_engine.dart';

export 'src/view_composer.dart';
export 'src/view_engine.dart';

class TemplatingBootstrapper extends Bootstrapper {
  final List engines;
  final String templatesDirectory;
  final Encoding encoding;
  final TemplateLoader _templateLoader;

  TemplatingBootstrapper({
  this.engines: const [],
  String templatesDirectory: 'web',
  Encoding encoding: UTF8
  }) : templatesDirectory = templatesDirectory,
       encoding = encoding,
       _templateLoader = new IoTemplateLoader(templatesDirectory, encoding);

  @Hook.bindings
  bindings() {
    engines.forEach(_verifyIsViewEngine);

    final composer = new ViewComposer(
        _templateLoader,
        new List.unmodifiable(
            engines.map((t) => container.make(t,
                injecting: {Encoding: encoding}
            ))
        )
    );

    container.singleton(composer, as: ViewComposer);
  }

  void _verifyIsViewEngine(engine) {
    final bool isViewEngine = (){
      if (engine is ViewEngine) return true;
      if (engine is! Type) return false;
      return reflectType(engine)
          .isAssignableTo(reflectType(ViewEngine));
    }();

    if (!isViewEngine) {
      throw new Exception('[$engine] is not a [ViewEngine]');
    }
  }
}

