@TestOn('browser')
import 'dart:async';

import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:pageloader/objects.dart';
import 'package:test/test.dart';

import 'app_test.template.dart' as ng;

class AppPO extends PageObjectBase {
  @ByTagName('h1')
  PageLoaderElement get _title => q('h1');

  @FirstByCss('div')
  PageLoaderElement get _id => q('div'); // e.g. 'id: 1'

  @ByTagName('h2')
  PageLoaderElement get _heroName => q('h2'); // e.g. 'Mr Freeze details!'

  @ByTagName('input')
  PageLoaderElement get _input => q('input');

  Future<String> get title => _title.visibleText;

  Future<int> get heroId async {
    final idAsString = (await _id.visibleText).split(':')[1];
    return int.parse(idAsString, onError: (_) => -1);
  }

  Future<String> get heroName async {
    final text = await _heroName.visibleText;
    return text.substring(0, text.lastIndexOf(' '));
  }

  Future type(String s) => _input.type(s);
}

void main() {
  ng.initReflector();
  final testBed = new NgTestBed<AppComponent>();
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    appPO = await new AppPO().resolve(fixture);
  });

  tearDown(disposeAnyRunningTest);

  test('title', () async {
    expect(await appPO.title, 'Tour of Heroes');
  });

  const windstormData = const <String, dynamic>{'id': 1, 'name': 'Windstorm'};

  test('initial hero properties', () async {
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name']);
  });

  const nameSuffix = 'X';

  test('update hero name', () async {
    await appPO.type(nameSuffix);
    expect(await appPO.heroId, windstormData['id']);
    expect(await appPO.heroName, windstormData['name'] + nameSuffix);
  });
}
