import 'package:ngrouter/ngrouter.dart';

const idParam = 'id';

class RoutePaths {
  static final dashboard = RoutePath(path: 'dashboard');
  static final heroes = RoutePath(path: 'heroes');

  static final hero = RoutePath(path: '${heroes.path}/:$idParam');
}

int? getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
