// Examples with car and engine variations
import 'car.dart';

///////// example 1 ////////////
Car simpleCar() {
  // Simple car with 4 cylinders and Flintstone tires.
  var car = new Car(new Engine(), new Tires());
  car.description = 'Simple';
  return car;
}
///////// example 2 ////////////

class Engine2 implements Engine {
  final int cylinders;

  Engine2(this.cylinders);
}

Car superCar() {
// Super car with 12 cylinders and Flintstone tires.
  var bigCylinders = 12;
  var car = new Car(new Engine2(bigCylinders), new Tires());
  car.description = 'Super';
  return car;
}
/////////// example 3 //////////

class MockEngine extends Engine {
  final int cylinders = 8;
}

class MockTires extends Tires {
  String make = 'YokoGoodStone';
}

Car testCar() {
// Test car with 8 cylinders and YokoGoodStone tires.
  var car = new Car(new MockEngine(), new MockTires());
  car.description = 'Test';
  return car;
}
