import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'flying_heroes_pipe.dart';
import 'heroes.dart';

@Component(
  selector: 'flying-heroes',
  templateUrl: 'flying_heroes_component.html',
  styles: const ['#flyers, #all {font-style: italic}'],
  pipes: const [FlyingHeroesPipe],
  directives: const [CORE_DIRECTIVES, formDirectives],
)
class FlyingHeroesComponent {
  List<Hero> heroes;
  bool canFly = true;
  bool mutate = true;
  String title = 'Flying Heroes (pure pipe)';

  FlyingHeroesComponent() {
    reset();
  }

  void addHero(String name) {
    name = name.trim();
    if (name.isEmpty) return;

    var hero = new Hero(name, canFly);
    if (mutate) {
      // Pure pipe won't update display because heroes list
      // reference is unchanged; Impure pipe will display.
      heroes.add(hero);
    } else {
      // Pipe updates display because heroes list is a new object
      heroes = new List<Hero>.from(heroes)..add(hero);
    }
  }

  void reset() {
    heroes = new List<Hero>.from(mockHeroes);
  }
}

//\\\\ Identical except for impure pipe \\\\\\
@Component(
  selector: 'flying-heroes-impure',
  templateUrl: 'flying_heroes_component.html',
  styles: const ['.flyers, .all {font-style: italic}'],
  pipes: const [FlyingHeroesImpurePipe],
  directives: const [CORE_DIRECTIVES, formDirectives],
)
class FlyingHeroesImpureComponent extends FlyingHeroesComponent {
  FlyingHeroesImpureComponent() {
    title = 'Flying Heroes (impure pipe)';
  }
}
