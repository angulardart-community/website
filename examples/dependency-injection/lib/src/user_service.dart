class User {
  final String name;
  final bool isAuthorized;

  User(this.name, [this.isAuthorized = false]);
}

// Todo: get the user; don't 'new' it.
final User _alice = User('Alice', true);
final User _bob = User('Bob', false);

class UserService {
  User user;

  UserService() : user = _bob;

  // swap users
  User getNewUser() => user = user == _bob ? _alice : _bob;
}
