@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'app_po.dart';

void main() {
  final testBed =
      NgTestBed.forComponent<AppComponent>(ng.AppComponentNgFactory);
  NgTestFixture<AppComponent> fixture;
  AppPO appPO;

  setUp(() async {
    fixture = await testBed.create();
    final context =
        new HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    appPO = new AppPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  test('title', () {
    expect(appPO.title, 'Tour of Heroes');
  });

  const windstormData = const <String, dynamic>{'id': 1, 'name': 'Windstorm'};

  test('initial hero properties', () {
    expect(appPO.heroId, windstormData['id']);
    expect(appPO.heroName, windstormData['name']);
  });

  const nameSuffix = 'X';

  test('update hero name', () async {
    await appPO.type(nameSuffix);
    expect(appPO.heroId, windstormData['id']);
    expect(appPO.heroName, windstormData['name'] + nameSuffix);
  });
}
