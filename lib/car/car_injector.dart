import 'package:angular2/core.dart';

import '../logger_service.dart';
import 'car.dart';

Car useInjector() {
  ReflectiveInjector injector;
  /*
  // Cannot instantiate an ReflectiveInjector like this!
  var injector = new ReflectiveInjector([Car, Engine, Tires]);
  */
  injector = ReflectiveInjector.resolveAndCreate([Car, Engine, Tires]);
  var car = injector.get(Car);
  car.description = 'Injector';

  injector = ReflectiveInjector.resolveAndCreate([Logger]);
  var logger = injector.get(Logger);
  logger.log('Injector car.drive() said: ' + car.drive());
  return car;
}
