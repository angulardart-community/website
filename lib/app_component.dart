import 'dart:async';

import 'package:angular/angular.dart';

import 'src/hero.dart';
import 'src/hero_detail_component.dart';
import 'src/hero_service.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: const ['app_component.css'],
  directives: const [coreDirectives, HeroDetailComponent],
  providers: const [HeroService],
)
class AppComponent implements OnInit {
  final title = 'Tour of Heroes';
  final HeroService _heroService;
  List<Hero> heroes;
  Hero selectedHero;

  AppComponent(this._heroService);

  Future<Null> getHeroes() async {
    heroes = await _heroService.getHeroes();
  }

  void ngOnInit() => getHeroes();

  void onSelect(Hero hero) => selectedHero = hero;
}
