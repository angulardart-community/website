import 'package:angular/angular.dart';
import 'heroes.dart';

@Pipe('flyingHeroes')
class FlyingHeroesPipe extends PipeTransform {
  List<Hero> transform(List<Hero> value) =>
      value.where((hero) => hero.canFly).toList();
}

// Identical except for the pure flag
@Pipe('flyingHeroes', pure: false)
class FlyingHeroesImpurePipe extends FlyingHeroesPipe {}
