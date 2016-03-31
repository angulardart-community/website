import 'package:angular2/platform/browser.dart';
import 'package:dependency_injection/app_component.dart';
import 'package:dependency_injection/heroes/hero_service.dart';

main() {
  bootstrap(AppComponent, [HeroService]); // DISCOURAGED (but works)
}
