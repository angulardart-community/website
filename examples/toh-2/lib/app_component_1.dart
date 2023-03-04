// Based on toh-1 file. USED ONLY TO VALIDATE the .html template
import 'package:ngdart/angular.dart';
import 'package:ngforms/ngforms.dart';

import 'src/hero.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component_1.html',
  directives: [formDirectives],
)
class AppComponent {
  final title = 'Tour of Heroes';
  Hero hero = Hero(1, 'Windstorm');
}
