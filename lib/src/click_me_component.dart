/* FOR DOCS ... MUST MATCH ClickMeComponent template
  <button (click)="onClickMe()">Click me!</button>
*/

import 'package:angular/angular.dart';

@Component(
  selector: 'click-me',
  template: '''
    <button (click)="onClickMe()">Click me!</button>
    {{clickMessage}}
  ''',
)
class ClickMeComponent {
  String clickMessage = '';

  void onClickMe() => clickMessage = 'You are my hero!';
}
