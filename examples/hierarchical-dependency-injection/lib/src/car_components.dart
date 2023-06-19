import 'package:angular/angular.dart';

import 'car_services.dart';

@Component(
  selector: 'c-car',
  template: '<div>C: {{description}}</div>',
  providers: [ClassProvider(CarService, useClass: CarService3)],
)
class CCarComponent {
  String description;
  CCarComponent(CarService carService) {
    this.description =
        '${carService.getCar().description} (${carService.name})';
  }
}

@Component(
  selector: 'b-car',
  template: '''
    <div>B: {{description}}</div>
    <c-car></c-car>
  ''',
  directives: [CCarComponent],
  providers: [
    ClassProvider(CarService, useClass: CarService2),
    ClassProvider(EngineService, useClass: EngineService2)
  ],
)
class BCarComponent {
  String description;
  BCarComponent(CarService carService) {
    this.description =
        '${carService.getCar().description} (${carService.name})';
  }
}

@Component(
  selector: 'a-car',
  template: '''
    <div>A: {{description}}</div>
    <b-car></b-car>
  ''',
  directives: [BCarComponent],
)
class ACarComponent {
  String description;
  ACarComponent(CarService carService) {
    this.description =
        '${carService.getCar().description} (${carService.name})';
  }
}

@Component(
  selector: 'my-cars',
  template: '''
    <h3>Cars</h3>
    <a-car></a-car>
  ''',
  directives: [ACarComponent],
)
class CarsComponent {}

const carComponents = [
  CarsComponent,
  ACarComponent,
  BCarComponent,
  CCarComponent,
];

// generic car-related services
const carServices = [
  ClassProvider(CarService),
  ClassProvider(EngineService),
  ClassProvider(TiresService),
];
