import 'package:angular/angular.dart';
import 'src/hero.dart';
import 'src/hero_app_main_component.dart';

@Component(
    selector: 'hero-app',
    template: '''
      <h1>Tour of Heroes</h1>
      <hero-app-main [hero]="hero"></hero-app-main>''',
    styles: const ['h1 { font-weight: normal; }'],
    directives: const [HeroAppMainComponent])
class AppComponent {
  Hero hero =
      new Hero('Human Torch', ['Mister Fantastic', 'Invisible Woman', 'Thing']);

  @HostBinding('class')
  String get themeClass => 'theme-light';
}
