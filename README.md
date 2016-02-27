# Templating for [Embla](https://github.com/emilniklas/embla)

## Usage with Embla
```dart
export 'package:embla/bootstrap.dart';
import 'package:embla/http.dart';

import 'package:embla_templates/embla_templates.dart';
import 'package:embla_templates/engines/html_view_engine.dart';
import 'package:embla_templates/engines/handlebars_view_engine.dart';

get embla => [
  new TemplatingBootstrapper(
    templatesDirectory: 'web',
    engines: [
      HandlebarsViewEngine,
      HtmlViewEngine,
    ]
  ),
  new HttpBootstrapper(
    pipeline: pipe(
      (ViewComposer view) { // Will be responding to each request

        // Given the configuration in the TemplatingBootstrapper,
        // `render` will look for `web/index.hbs` or `web/index.html`
        return view.render('index')
          ..localVariableThatWillBeAvailableInTheTemplate = "value";
      }
    )
  )
];
```

## Usage without Embla
```dart
import 'package:embla_templates/embla_templates.dart';
import 'package:embla_templates/engines/html_view_engine.dart';

import 'package:shelf/shelf.dart' as shelf;

main() async {
  final view = new ViewComposer.create(
    templatesDirectory: 'web',
    engines: [
      new HtmlViewEngine()
    ]
  );

  // Turn index.html into a Template -- a Future Shelf Response
  Template template = view.render('index')
    ..localVariableThatWillBeAvailableInTheTemplate = "value";

  // Future<shelf.Response> is a valid return value in a shelf.Handler
  shelf.Response response = await template;
}
```
