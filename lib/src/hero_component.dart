// #docregion v2
import 'dart:async';

import 'package:ngdart/angular.dart';
import 'package:ngforms/ngforms.dart';
import 'package:ngrouter/ngrouter.dart';

import 'hero.dart';
import 'hero_service.dart';
import 'route_paths.dart';

@Component(
  selector: 'my-hero',
  templateUrl: 'hero_component.html',
  styleUrls: ['hero_component.css'],
  directives: [coreDirectives, formDirectives],
)
class HeroComponent implements OnActivate {
  Hero? hero;
  final HeroService _heroService;
  final Location _location;

  HeroComponent(this._heroService, this._location);

  @override
  void onActivate(_, RouterState current) async {
    final id = getId(current.parameters);
    if (id != null) hero = await (_heroService.get(id));
  }

  // #docregion save
  Future<void> save() async {
    await _heroService.update(hero!);
    goBack();
  }
  // #enddocregion save

  void goBack() => _location.back();
}
