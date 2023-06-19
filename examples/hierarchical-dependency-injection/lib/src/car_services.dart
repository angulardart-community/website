/// Model
class Car {
  String name = 'Avocado Motors';
  Engine engine;
  Tires tires;

  Car(this.engine, this.tires);

  String get description => '$name car with '
      '${engine.cylinders} cylinders and '
      '${tires.make} tires.';
}

class Engine {
  int cylinders = 4;
}

class Tires {
  String make = 'Flintstone';
  String model = 'Square';
}

//// Engine services ///
class EngineService {
  String id;
  EngineService() : id = 'E1';

  Engine getEngine() => Engine();
}

class EngineService2 extends EngineService {
  EngineService2() {
    id = 'E2';
  }

  @override
  Engine getEngine() => Engine()..cylinders = 8;
}

//// Tire services ///
class TiresService {
  final id = 'T1';
  Tires getTires() => Tires();
}

/// Car Services ///
class CarService {
  EngineService engineService;
  TiresService tiresService;
  String id;

  CarService(this.engineService, this.tiresService) : id = 'C1';

  Car getCar() => Car(engineService.getEngine(), tiresService.getTires());

  String get name => '$id-${engineService.id}-${tiresService.id}';
}

class CarService2 extends CarService {
  CarService2(EngineService engineService, TiresService tiresService)
      : super(engineService, tiresService) {
    id = 'C2';
  }

  @override
  Car getCar() => super.getCar()..name = 'BamBam Motors, BroVan 2000';
}

class CarService3 extends CarService2 {
  CarService3(EngineService engineService, TiresService tiresService)
      : super(engineService, tiresService) {
    id = 'C3';
  }

  @override
  Car getCar() =>
      super.getCar()..name = 'Chizzamm Motors, Calico UltraMax Supreme';
}
