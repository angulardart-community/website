import 'package:angular2/core.dart';

@Injectable()
class AppConfig {
  final apiEndpoint;
  final String title;

  const AppConfig(this.apiEndpoint, this.title);
}

const config1 = const AppConfig('api.heroes.com', 'Dependency Injection');
