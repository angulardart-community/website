import 'package:angular2/core.dart';

import 'hero.dart';
import 'hero_detail_component.dart';
import 'hero_service_1.dart';

// Testable but never shown
@Component(
    selector: 'my-app',
    template: '''
    <div *ngFor="let hero of heroes" (click)="onSelect(hero)">
      {{hero.name}}
    </div>
    <my-hero-detail [hero]="selectedHero"></my-hero-detail>
    ''',
    directives: const [HeroDetailComponent],
    providers: const [HeroService])
class AppComponent implements OnInit {
  String title = 'Tour of Heroes';
  List<Hero> heroes;
  Hero selectedHero;

  HeroService heroService = new HeroService(); // don't do this
  final HeroService _heroService;
  AppComponent(this._heroService);

  void getHeroes() {
    heroes = _heroService.getHeroes();
  }

  void ngOnInit() {
    getHeroes();
  }

  void onSelect(Hero hero) {
    selectedHero = hero;
  }
}
