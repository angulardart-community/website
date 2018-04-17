import 'package:angular/angular.dart';

import '../logger_service.dart';
import '../user_service.dart';
import 'hero_service.dart';

HeroService heroServiceFactory(Logger logger, UserService userService) =>
    new HeroService(logger, userService.user.isAuthorized);

const heroServiceProvider =
    const FactoryProvider(HeroService, heroServiceFactory);
