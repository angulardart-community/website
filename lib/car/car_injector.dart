import 'package:angular2/core.dart';

import '../logger_service.dart';
import 'car.dart';

Car useInjector() {
  Injector injector;

  /*
  // Cannot 'new' an Injector like this!
  var injector = new Injector([Car, Engine, Tires, Logger]);
*/

  injector = Injector.resolveAndCreate([Car, Engine, Tires, Logger]);
  var car = injector.get(Car);

  car.description = 'Injector';
  var logger = injector.get(Logger);
  logger.log('Injector car.drive() said: ' + car.drive());
  return car;
}
