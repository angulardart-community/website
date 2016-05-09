import 'package:angular2/core.dart';

import '../logger_service.dart';
import 'car.dart';

Car useInjector() {
  ReflectiveInjector injector;

  /*
  // Cannot 'new' an ReflectiveInjector like this!
  var injector = new ReflectiveInjector([Car, Engine, Tires, Logger]);
*/

  injector = ReflectiveInjector.resolveAndCreate([Car, Engine, Tires, Logger]);
  var car = injector.get(Car);

  car.description = 'Injector';
  var logger = injector.get(Logger);
  logger.log('Injector car.drive() said: ' + car.drive());
  return car;
}
