@TestOn('browser')

import 'package:ngtest/ngtest.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
import 'package:ngpageloader/html.dart';
import 'package:test/test.dart';

import 'app_po.dart';

late NgTestFixture<AppComponent> fixture;
late AppPO appPO;

void main() {
  final testBed = NgTestBed<AppComponent>(ng.AppComponentNgFactory);

  setUp(() async {
    fixture = await testBed.create();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    appPO = AppPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  group('Basics:', basicTests);
  group('Select hero:', selectHeroTests);
}

void basicTests() {
  test('page title', () {
    expect(appPO.pageTitle, 'Tour of Heroes');
  });

  test('tab title', () {
    expect(appPO.tabTitle, 'Heroes');
  });

  test('hero count', () {
    expect(appPO.heroes.length, 10);
  });

  test('no selected hero', () {
    expect(appPO.selected, null);
  });
}

void selectHeroTests() {
  const targetHero = {'id': 16, 'name': 'RubberMan'};

  setUp(() async {
    await appPO.selectHero(5);
  });

  test('is selected', () async {
    expect(await appPO.selected, targetHero);
  });

  test('show hero details', () {
    expect(appPO.heroFromDetails, targetHero);
  });

  group('Update hero:', () {
    const nameSuffix = 'X';
    final updatedHero = Map.from(targetHero);
    updatedHero['name'] = "${targetHero['name']}$nameSuffix";

    setUp(() async {
      await appPO.type(nameSuffix);
    });

    tearDown(() async {
      // Restore hero name
      await appPO.clear();
      await appPO.type(targetHero['name'] as String);
    });

    test('name in list is updated', () {
      expect(appPO.selected, updatedHero);
    });

    test('name in details view is updated', () {
      expect(appPO.heroFromDetails, updatedHero);
    });
  });
}
