import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

import 'hero.dart';

const List<String> _powers = const [
  'Really Smart',
  'Super Flexible',
  'Super Hot',
  'Weather Changer'
];

@Component(
  selector: 'hero-form',
  templateUrl: 'hero_form_component.html',
  directives: const [CORE_DIRECTIVES, formDirectives],
)
class HeroFormComponent {
  Hero model = new Hero(18, 'Dr IQ', _powers[0], 'Chuck Overstreet');
  bool submitted = false;

  List<String> get powers => _powers;

  void onSubmit() => submitted = true;

  /// Returns a map of CSS class names representing the state of [control].
  Map<String, bool> setCssValidityClass(NgControl control) {
    final validityClass = control.valid == true ? 'is-valid' : 'is-invalid';
    return {validityClass: true};
  }

  void clear() {
    model.name = '';
    model.power = _powers[0];
    model.alterEgo = '';
  }
}

Hero skyDog() {
  var myHero = new Hero(
      42, 'SkyDog', 'Fetch any object at any distance', 'Leslie Rollover');
  print('My hero is ${myHero.name}.'); // "My hero is SkyDog."
  return myHero;
}
