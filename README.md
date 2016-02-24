# Templating for [Embla](https://github.com/emilniklas/embla)

## Usage with Embla
```dart
export 'package:embla/bootstrap.dart';
import 'package:embla/http.dart';

import 'package:embla_templates/embla_templates.dart';
import 'package:embla_templates/engines/html_view_engine.dart';

get embla => [
  new HttpBootstrapper(
    pipeline: pipe(
      (ViewComposer view) { // Will be responding to each request

        return view.render('index');
      }
    )
  ),
  new TemplatingBootstrapper(
    templatesDirectory: 'web',
    engines: [
      HtmlViewEngine
    ]
  )
];
```

## Usage without Embla
```dart
import 'dart:convert' show UTF8;

import 'package:embla_templates/embla_templates.dart';
import 'package:embla_templates/engines/html_view_engine.dart';

main() {
  final view = new ViewComposer.create(
    templatesDirectory: 'web',
    engines: [
      new HtmlViewEngine()
    ]
  );

  // Turn index.html into a Template -- a Future Shelf Response
  Template response = view.render('index');
}
```
