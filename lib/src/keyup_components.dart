import 'dart:html';

import 'package:angular/angular.dart';

@Component(
  selector: 'key-up1',
  template: '''
    <input (keyup)="onKey(\$event)">
    <p>{{values}}</p>
  ''',
)
class KeyUpComponentV1 {
  String values = '';

  /*
  onKey(dynamic event) {
    values += event.target.value + ' | ';
  }
  */
  onKey(KeyboardEvent event) {
    InputElement el = event.target;
    values += '${el.value}  | ';
  }
}

//////////////////////////////////////////

@Component(
  selector: 'key-up2',
  template: '''
    <input #box (keyup)="onKey(box.value)">
    <p>{{values}}</p>
  ''',
)
class KeyUpComponentV2 {
  String values = '';
  onKey(value) => values += '$value | ';
}

//////////////////////////////////////////

@Component(
  selector: 'key-up3',
  template: '''
    <input #box (keyup.enter)="values=box.value">
    <p>{{values}}</p>
  ''',
)
class KeyUpComponentV3 {
  String values = '';
}

//////////////////////////////////////////

@Component(
  selector: 'key-up4',
  template: '''
    <input #box
      (keyup.enter)="values=box.value"
      (blur)="values=box.value">
    <p>{{values}}</p>
  ''',
)
class KeyUpComponentV4 {
  String values = '';
}
