// #docregion v2
import 'package:ngdart/angular.dart';
import 'package:ngforms/ngforms.dart';
// #docregion added-imports
import 'package:ngrouter/ngrouter.dart';
// #enddocregion added-imports

import 'hero.dart';
// #docregion added-imports
import 'hero_service.dart';
import 'route_paths.dart';
// #enddocregion added-imports

// #docregion metadata, metadata-wo-style
@Component(
  selector: 'my-hero',
  // #docregion templateUrl
  templateUrl: 'hero_component.html',
  // #enddocregion metadata-wo-style, templateUrl, v2
  styleUrls: ['hero_component.css'],
  // #docregion metadata-wo-style
  directives: [coreDirectives, formDirectives],
  // #docregion v2
)
// #enddocregion metadata, metadata-wo-style
// #docregion OnActivate, hero
class HeroComponent implements OnActivate {
  // #enddocregion OnActivate
  Hero? hero;
  // #enddocregion hero
  // #docregion ctor
  final HeroService _heroService;
  final Location _location;

  HeroComponent(this._heroService, this._location);
  // #enddocregion ctor

  // #docregion OnActivate
  @override
  void onActivate(_, RouterState current) async {
    final id = getId(current.parameters);
    if (id != null) hero = await (_heroService.get(id));
  }
  // #enddocregion OnActivate

  // #docregion goBack
  void goBack() => _location.back();
  // #enddocregion goBack
  // #docregion hero, OnActivate
}
