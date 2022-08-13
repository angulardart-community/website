import 'package:ngdart/angular.dart';
import 'package:ngforms/ngforms.dart';

import 'hero.dart';

@Component(
  selector: 'my-hero',
  template: '''
    <div *ngIf="hero != null">
      <h2>{{hero!.name}}</h2>
      <div><label>id: </label>{{hero!.id}}</div>
      <div>
        <label>name: </label>
        <input [(ngModel)]="hero!.name" placeholder="name"/>
      </div>
    </div>
  ''',
  directives: [coreDirectives, formDirectives],
)
class HeroComponent {
  @Input()
  Hero? hero;

  void bruh(Hero? h) {
    if (h != null) {
      print(h.name);
    }
  }
}
