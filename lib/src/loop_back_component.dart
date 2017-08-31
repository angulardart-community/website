import 'package:angular/angular.dart';

@Component(
  selector: 'loop-back',
  template: '''
    <input #box (keyup)="0">
    <p>{{box.value}}</p>
  ''',
)
class LoopBackComponent {}
