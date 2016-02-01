import 'view_composer.dart';
import 'view_engine.dart';
import 'package:embla/http.dart';

class View {
  final ViewComposer composer;
  final Request request;

  View(this.composer, this.request);

  Template render(String template, {int statusCode: 200}) {
    return composer.render(
        template,
        statusCode: statusCode,
        request: request
    );
  }
}
