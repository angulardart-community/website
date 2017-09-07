import 'package:angular/angular.dart';

import 'src/hero.dart';
import 'src/hero_detail_component.dart';

final List<Hero> mockHeroes = [
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
  template: '''
    <h1>{{title}}</h1>
    <h2>My Heroes</h2>
    <ul class="heroes">
      <li *ngFor="let hero of heroes"
        [class.selected]="hero == selectedHero"
        (click)="onSelect(hero)">
        <span class="badge">{{hero.id}}</span> {{hero.name}}
      </li>
    </ul>
    <hero-detail [hero]="selectedHero"></hero-detail>
  ''',
  styleUrls: const ['app_component.css'],
  directives: const [CORE_DIRECTIVES, HeroDetailComponent],
)
class AppComponent {
  final title = 'Tour of Heroes';
  final List<Hero> heroes = mockHeroes;
  Hero selectedHero;

  void onSelect(Hero hero) {
    selectedHero = hero;
  }
}
