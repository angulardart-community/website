import 'package:angular2/core.dart';

import 'hero.dart';
import 'hero_service_1.dart';
/*
import 'hero_service.dart';
*/

@Component(
    selector: 'hero-list',
    template: '''
      <div *ngFor="let hero of heroes">
        {{hero.id}} - {{hero.name}}
      </div>''')
class HeroListComponent {
  final List<Hero> heroes;

  HeroListComponent(HeroService heroService) : heroes = heroService.getHeroes();
}
