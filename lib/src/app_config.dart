import 'package:angular/angular.dart';

const appTitleToken = const OpaqueToken<String>('app.title');

const appTitle = 'Dependency Injection';

const appConfigMap = const {
  'apiEndpoint': 'api.heroes.com',
  'title': 'Dependency Injection',
  // ...
};

const appConfigMapToken = const OpaqueToken<Map>('app.config');

class AppConfig {
  String apiEndpoint;
  String title;
}

AppConfig appConfigFactory() => new AppConfig()
  ..apiEndpoint = 'api.heroes.com'
  ..title = 'Dependency Injection';
