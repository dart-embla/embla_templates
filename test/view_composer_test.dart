import 'package:quark/unit.dart';
import 'package:embla_templates/embla_templates.dart';
import 'dart:async';
import 'package:embla_templates/engines/txt_view_engine.dart';
export 'package:quark/init.dart';

class TestTemplateLoader implements TemplateLoader {
  static const Map<String, String> templates = const {
    'itWorks.txt': 'x',
    'itHandlesMultipleEngines.x': 'y',
    'itWorks.x': 'z',
  };

  Future<bool> exists(String filename) async {
    return templates.containsKey(filename);
  }

  Stream<String> load(String filename) {
    return new Stream<String>.fromIterable(templates[filename].split('\n'));
  }
}

class ViewComposerTest extends UnitTest {

  ViewComposer get composer => new ViewComposer(
      new TestTemplateLoader(),
      [
        new TxtViewEngine(),
        new TestViewEngine(),
      ]
  );

  @test
  itWorks() async {
    final output = await composer.render('itWorks').then((t) => t.readAsString());
    expect(output, 'x');
  }

  @test
  itThrowsWhenThereIsNoMatchingTemplate() async {
    expect(
        composer.render('doesntExist').then((t) => t.readAsString()),
        throwsA(new isInstanceOf<TemplateNotFoundException>())
    );
  }

  @test
  itHandlesMultipleEngines() async {
    final output = await composer
        .render('itHandlesMultipleEngines').then((t) => t.readAsString());
    expect(output, 'y');
  }
}

class TestViewEngine extends TxtViewEngine {
  final Iterable<String> extensions = ['.x'];
}
