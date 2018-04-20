import 'package:angular/angular.dart';

import 'app_config.dart';
import 'heroes/hero_service_provider.dart';
import 'heroes/hero_service.dart';
import 'logger_service.dart';
import 'user_service.dart';

abstract class _Base {
  final Logger logger;
  _Base([this.logger]);

  void log(String msg) => logger?.fine(msg);
}

@Component(
  selector: 'class-provider',
  template: '{{logger}}',
  providers: [
    const ClassProvider(Logger),
  ],
)
class ClassProviderComponent extends _Base {
  ClassProviderComponent(Logger logger) : super(logger);
}

@Injectable()
class BetterLogger extends Logger {}

@Component(
  selector: 'use-class',
  template: '{{logger}}',
  providers: [
    const ClassProvider(Logger, useClass: BetterLogger),
  ],
)
class ClassProviderUseClassComponent extends _Base {
  ClassProviderUseClassComponent(Logger logger) : super(logger);
}

@Injectable()
class EvenBetterLogger extends Logger {
  final UserService _userService;

  EvenBetterLogger(this._userService);

  String toString() => super.toString() + ' (user:${_userService.user.name})';
}

@Component(
  selector: 'use-class-deps',
  template: '{{logger}}',
  providers: [
    const ClassProvider(UserService),
    const ClassProvider(Logger, useClass: EvenBetterLogger),
  ],
)
class ServiceWithDepsComponent extends _Base {
  ServiceWithDepsComponent(Logger logger) : super(logger);
}

@Injectable()
class NewLogger extends Logger implements OldLogger {}

class OldLogger extends Logger {
  OldLogger() {
    throw new Exception("Don't call the Old Logger!");
  }
}

@Component(
  selector: 'two-new-loggers',
  template: '{{logger}}',
  providers: [
    const ClassProvider(NewLogger),
    const ClassProvider(OldLogger, useClass: NewLogger),
  ],
)
class TwoNewLoggersComponent extends _Base {
  TwoNewLoggersComponent(NewLogger logger, OldLogger o) : super(logger) {
    log('The newLogger and oldLogger are identical: ${identical(logger, o)}');
  }
}

@Component(
  selector: 'existing-provider',
  template: '{{logger}}',
  providers: [
    const ClassProvider(NewLogger),
    const ExistingProvider(OldLogger, NewLogger),
  ],
)
class ExistingProviderComponent extends _Base {
  ExistingProviderComponent(NewLogger logger, OldLogger o) : super(o) {
    log('The newLogger and oldLogger are identical: ${identical(logger, o)}');
  }
}

class SilentLogger implements Logger {
  const SilentLogger();
  @override
  void fine(String msg) {}
  @override
  String toString() => '';
}

const silentLogger = const SilentLogger();

@Component(
  selector: 'value-provider',
  template: '{{logger}}',
  providers: [
    const ValueProvider(Logger, silentLogger),
  ],
)
class ValueProviderComponent extends _Base {
  ValueProviderComponent(Logger logger) : super(logger) {
    log('Hello?');
  }
}

@Component(
  selector: 'factory-provider',
  template: '{{logger}}',
  providers: [
    heroServiceProvider,
    const ClassProvider(Logger),
    const ClassProvider(UserService),
  ],
)
class FactoryProviderComponent extends _Base {
  FactoryProviderComponent(Logger o, HeroService heroService) : super(o) {
    log('Got ${heroService.getAll().length} heroes');
  }
}

@Component(
  selector: 'value-provider-for-token',
  template: '{{log}}',
  providers: [const ValueProvider.forToken(appTitleToken, appTitle)],
)
class ValueProviderForTokenComponent {
  String log;

  ValueProviderForTokenComponent(@Inject(appTitleToken) title)
      : log = 'App config map title is $title';
}

@Component(
  selector: 'value-provider-for-map',
  template: '{{log}}',
  providers: [const ValueProvider.forToken(appConfigMapToken, appConfigMap)],
)
class ValueProviderForMapComponent {
  String log;

  ValueProviderForMapComponent(@Inject(appConfigMapToken) Map config) {
    final title = config == null ? 'null config' : config['title'];
    log = 'App config map title is $title';
  }
}

@Component(
  selector: 'optional-injection',
  template: '{{message}}',
  providers: [
    const ValueProvider(Logger, null),
  ],
)
class HeroService1 extends _Base {
  String message;
  HeroService1(@Optional() Logger logger) : super(logger) {
    logger?.fine('Hello');
    message = 'Optional logger is $logger';
  }
}

@Component(
  selector: 'my-providers',
  template: '''
    <h2>Provider variations</h2>

    <class-provider></class-provider>
    <use-class></use-class>
    <use-class-deps></use-class-deps>
    <two-new-loggers></two-new-loggers>
    <existing-provider></existing-provider>
    <value-provider></value-provider>
    <factory-provider></factory-provider>
    <value-provider-for-token></value-provider-for-token>
    <value-provider-for-map></value-provider-for-map>
    <optional-injection></optional-injection>
  ''',
  directives: [
    ClassProviderComponent,
    ClassProviderUseClassComponent,
    ServiceWithDepsComponent,
    TwoNewLoggersComponent,
    ExistingProviderComponent,
    ValueProviderComponent,
    FactoryProviderComponent,
    ValueProviderForTokenComponent,
    ValueProviderForMapComponent,
    HeroService1
  ],
)
class ProvidersComponent {}
