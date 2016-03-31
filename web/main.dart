import 'package:angular2/platform/browser.dart';

import 'package:hierarchical_di/heroes_list_component.dart';
import 'package:hierarchical_di/heroes_service.dart';

void main() {
  bootstrap(HeroesListComponent, [HeroesService]);
}

/* Documentation artifact below
// Don't do this!
bootstrap(HeroesListComponent, [HeroesService, RestoreService])
*/
