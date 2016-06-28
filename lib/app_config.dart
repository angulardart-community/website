import 'package:angular2/core.dart';

const APP_CONFIG = const OpaqueToken('app.config');

const Map heroDiConfig = const <String, String>{
  'apiEndpoint': 'api.heroes.com',
  'title': 'Dependency Injection'
};

class AppConfig {
  String apiEndpoint;
  String title;
}

AppConfig heroDiConfigFactory() => new AppConfig()
  ..apiEndpoint = 'api.heroes.com'
  ..title = 'Dependency Injection';

const appConfigProvider =
    const Provider(APP_CONFIG, useFactory: heroDiConfigFactory, deps: const []);
