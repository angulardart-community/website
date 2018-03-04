import 'package:angular/angular.dart';
import 'hero.dart';

@Component(
  selector: 'hero-team',
  template: '''
      <link rel="stylesheet" href="hero_team_component.css">
      <h3>Team</h3>
      <ul>
        <li *ngFor="let member of hero.team">
          {{member}}
        </li>
      </ul>''',
  directives: const [coreDirectives],
)
class HeroTeamComponent {
  @Input()
  Hero hero;
}
