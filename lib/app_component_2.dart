import 'package:angular2/core.dart';

const List<String> _heroes = const [
  'Windstorm',
  'Bombasto',
  'Magneta',
  'Tornado'
];

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
</ul>''')
class AppComponent {
  String title = 'Tour of Heroes';
  List<String> heroes = _heroes;
  String myHero = _heroes[0];
}
