import 'package:angular/angular.dart';

//import 'package:displaying_data/app_component_1.dart' as v1;
//import 'package:displaying_data/app_component_2.dart' as v2;
//import 'package:displaying_data/app_component_3.dart' as v3;
import 'package:displaying_data/app_component.dart';

import 'main.template.dart' as ng;

void main() {
// pick one
//  bootstrapStatic(v1.AppComponent, [], ng.initReflector);
//  bootstrapStatic(v2.AppComponent, [], ng.initReflector);
//  bootstrapStatic(v3.AppComponent, [], ng.initReflector);
  bootstrapStatic(AppComponent, [], ng.initReflector);
}
