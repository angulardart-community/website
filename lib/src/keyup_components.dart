import 'dart:html';

import 'package:angular/angular.dart';

@Component(
  selector: 'key-up1-untyped',
  template: '''
    <input (keyup)="onKey(\$event)">
    <p>{{values}}</p>
  ''',
)
class KeyUp1Component_untyped {
  String values = '';

  void onKey(dynamic event) {
    values += event.target.value + ' | ';
  }
}

@Component(
  selector: 'key-up1',
  template: '''
    <input (keyup)="onKey(\$event)">
    <p>{{values}}</p>
  ''',
)
class KeyUp1Component {
  String values = '';

  void onKey(KeyboardEvent event) {
    InputElement el = event.target;
    values += '${el.value}  | ';
  }
}

@Component(
  selector: 'key-up2',
  template: '''
    <input #box (keyup)="onKey(box.value)">
    <p>{{values}}</p>
  ''',
)
class KeyUp2Component {
  String values = '';
  void onKey(value) => values += '$value | ';
}

@Component(
  selector: 'key-up3',
  template: '''
    <input #box (keyup.enter)="values=box.value">
    <p>{{values}}</p>
  ''',
)
class KeyUp3Component {
  String values = '';
}

@Component(
  selector: 'key-up4',
  template: '''
    <input #box
      (keyup.enter)="values=box.value"
      (blur)="values=box.value">
    <p>{{values}}</p>
  ''',
)
class KeyUp4Component {
  String values = '';
}
