import 'package:angular2/core.dart';

@Component(
    selector: 'my-app',
    template: '''
      <h1>{{title}}</h1>
      <h2>My favorite hero is: {{myHero}}</h2>
      <p>Heroes:</p>
      <ul>
        <li *ngFor="let hero of heroes">
          {{ hero }}
        </li>
      </ul>
    ''')
class AppComponent {
  String title = 'Tour of Heroes';
  List<String> heroes = ['Windstorm', 'Bombasto', 'Magneta', 'Tornado'];
  String get myHero => heroes.first;
}
