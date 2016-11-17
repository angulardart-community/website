// Examples of provider arrays
import 'package:angular2/core.dart';

import 'app_config.dart';
import 'heroes/hero_service_provider.dart';
import 'heroes/hero_service.dart';
import 'logger_service.dart';
import 'user_service.dart';

// TODO file an issue: cannot use the following const in metadata.
const template = '{{log}}';

@Component(
    selector: 'provider-1', template: '{{log}}', providers: const [Logger])
class Provider1Component {
  String log;

  Provider1Component(Logger logger) {
    logger.log('Hello from logger provided with Logger class');
    log = logger.logs[0];
  }
}

/// Component just used to ensure that shared E2E tests pass.
@Component(
    selector: 'provider-3',
    template: '{{log}}',
    providers: const [const Provider(Logger, useClass: Logger)])
class Provider3Component {
  String log;

  Provider3Component(Logger logger) {
    logger.log('Hello from logger provided with useClass:Logger');
    log = logger.logs[0];
  }
}

@Injectable()
class BetterLogger extends Logger {}

@Component(
    selector: 'provider-4',
    template: '{{log}}',
    providers: const [const Provider(Logger, useClass: BetterLogger)])
class Provider4Component {
  String log;

  Provider4Component(Logger logger) {
    logger.log('Hello from logger provided with useClass:BetterLogger');
    log = logger.logs[0];
  }
}

@Injectable()
class EvenBetterLogger extends Logger {
  final UserService _userService;

  EvenBetterLogger(this._userService);

  @override
  void log(String message) {
    var name = _userService.user.name;
    super.log('Message to $name: $message');
  }
}

@Component(selector: 'provider-5', template: '{{log}}', providers: const [
  UserService,
  const Provider(Logger, useClass: EvenBetterLogger)
])
class Provider5Component {
  String log;

  Provider5Component(Logger logger) {
    logger.log('Hello from EvenBetterlogger');
    log = logger.logs[0];
  }
}

@Injectable()
class NewLogger extends Logger implements OldLogger {}

class OldLogger extends Logger {
  @override
  void log(String message) {
    throw new Exception('Should not call the old logger!');
  }
}

@Component(selector: 'provider-6a', template: '{{log}}', providers: const [
  NewLogger,
  // Not aliased! Creates two instances of `NewLogger`
  const Provider(OldLogger, useClass: NewLogger)
])
class Provider6aComponent {
  String log;

  Provider6aComponent(NewLogger newLogger, OldLogger oldLogger) {
    if (newLogger == oldLogger) {
      throw new Exception('expected the two loggers to be different instances');
    }
    oldLogger.log('Hello OldLogger (but we want NewLogger)');
    // The newLogger wasn't called so no logs[]
    // display the logs of the oldLogger.
    log = newLogger.logs.isEmpty ? oldLogger.logs[0] : newLogger.logs[0];
  }
}

@Component(selector: 'provider-6b', template: '{{log}}', providers: const [
  NewLogger,
  // Alias OldLogger with reference to NewLogger
  const Provider(OldLogger, useExisting: NewLogger)
])
class Provider6bComponent {
  String log;

  Provider6bComponent(NewLogger newLogger, OldLogger oldLogger) {
    if (newLogger != oldLogger) {
      throw new Exception('expected the two loggers to be the same instance');
    }
    oldLogger.log('Hello from NewLogger (via aliased OldLogger)');
    log = newLogger.logs[0];
  }
}

class SilentLogger implements Logger {
  @override
  final List<String> logs = const [
    'Silent logger says "Shhhhh!". Provided via "useValue"'
  ];

  const SilentLogger();

  @override
  void log(String message) {}
}

const silentLogger = const SilentLogger();

@Component(
    selector: 'provider-7',
    template: '{{log}}',
    providers: const [const Provider(Logger, useValue: silentLogger)])
class Provider7Component {
  String log;

  Provider7Component(Logger logger) {
    logger.log('Hello from logger provided with useValue');
    log = logger.logs[0];
  }
}

@Component(
    selector: 'provider-8',
    template: '{{log}}',
    providers: const [heroServiceProvider, Logger, UserService])
class Provider8Component {
  // must be true else this component would have blown up at runtime
  var log = 'Hero service injected successfully via heroServiceProvider';

  Provider8Component(HeroService heroService);
}

@Component(
    selector: 'provider-9',
    template: '{{log}}',
    providers: const [const Provider(APP_CONFIG, useValue: heroDiConfig)])
class Provider9Component implements OnInit {
  Map _config;
  String log;

  Provider9Component(@Inject(APP_CONFIG) this._config);

  @override
  void ngOnInit() {
    log = 'APP_CONFIG Application title is ${_config['title']}';
  }
}

// Sample providers 1 to 7 illustrate a required logger dependency.
// Optional logger, can be null.
@Component(
    selector: 'provider-10',
    template: '{{log}}',
    providers: const [const Provider(Logger, useValue: null)])
class Provider10Component implements OnInit {
  final Logger _logger;
  String log;

  /*
  HeroService(@Optional() this._logger) {
   */
  Provider10Component(@Optional() this._logger) {
    const someMessage = 'Hello from the injected logger';
    _logger?.log(someMessage);
  }

  @override
  void ngOnInit() {
    log =
        _logger == null ? 'Optional logger was not available' : _logger.logs[0];
  }
}

@Component(
    selector: 'my-providers',
    template: '''
      <h2>Provider variations</h2>
      <div id="p1"><provider-1></provider-1></div>
      <div id="p3"><provider-3></provider-3></div>
      <div id="p4"><provider-4></provider-4></div>
      <div id="p5"><provider-5></provider-5></div>
      <div id="p6a"><provider-6a></provider-6a></div>
      <div id="p6b"><provider-6b></provider-6b></div>
      <div id="p7"><provider-7></provider-7></div>
      <div id="p8"><provider-8></provider-8></div>
      <div id="p9"><provider-9></provider-9></div>
      <div id="p10"><provider-10></provider-10></div>''',
    directives: const [
      Provider1Component,
      Provider3Component,
      Provider4Component,
      Provider5Component,
      Provider6aComponent,
      Provider6bComponent,
      Provider7Component,
      Provider8Component,
      Provider9Component,
      Provider10Component
    ])
class ProvidersComponent {}
