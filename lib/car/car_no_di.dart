// Car without DI

import 'car.dart';

class Car {
  Engine engine;
  Tires tires;
  var description = 'No DI';

  Car() {
    engine = new Engine();
    tires = new Tires();
  }

  // Method using the engine and tires
  String drive() => '$description car with '
      '${engine.cylinders} cylinders and '
      '${tires.make} tires.';
}
