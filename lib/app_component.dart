import 'package:angular/angular.dart';

import 'src/highlight_directive.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [HighlightDirective])
class AppComponent {
  String color;
}
