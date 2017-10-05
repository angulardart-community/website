import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

class Hero {
  final int id;
  String name;

  Hero(this.id, this.name);
}

final mockHeroes = <Hero>[
  new Hero(11, 'Mr. Nice'),
  new Hero(12, 'Narco'),
  new Hero(13, 'Bombasto'),
  new Hero(14, 'Celeritas'),
  new Hero(15, 'Magneta'),
  new Hero(16, 'RubberMan'),
  new Hero(17, 'Dynama'),
  new Hero(18, 'Dr IQ'),
  new Hero(19, 'Magma'),
  new Hero(20, 'Tornado')
];

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, formDirectives],
)
class AppComponent {
  final title = 'Tour of Heroes';
  final List<Hero> heroes = mockHeroes;
  Hero selectedHero;

  void onSelect(Hero hero) {
    selectedHero = hero;
  }
}
