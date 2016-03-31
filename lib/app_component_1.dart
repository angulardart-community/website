import 'package:angular2/core.dart';

@Component(
    selector: 'my-app',
    template: '''
<h1>{{title}}</h1>
<h2>My favorite hero is: {{myHero}}</h2>''')
class AppComponent {
  String title = 'Tour of Heroes';
  String myHero = 'Windstorm';
}
