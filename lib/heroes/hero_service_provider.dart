import 'package:angular2/core.dart';

import '../logger_service.dart';
import '../user_service.dart';
import 'hero_service.dart';

HeroService heroServiceFactory(Logger logger, UserService userService) =>
    new HeroService(logger, userService.user.isAuthorized);

const heroServiceProvider = const Provider(HeroService,
    useFactory: heroServiceFactory, deps: const [Logger, UserService]);
