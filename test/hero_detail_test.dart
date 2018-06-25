@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/hero.dart';
import 'package:angular_tour_of_heroes/src/hero_component.dart';
import 'package:angular_tour_of_heroes/src/hero_component.template.dart' as ng;
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'hero_detail_po.dart';

const targetHero = {'id': 1, 'name': 'Alice'};

NgTestFixture<HeroComponent> fixture;
HeroDetailPO po;

void main() {
  final testBed =
      NgTestBed.forComponent<HeroComponent>(ng.HeroComponentNgFactory);

  tearDown(disposeAnyRunningTest);

  group('No initial @Input() hero:', () {
    setUp(() async {
      fixture = await testBed.create();
      final context =
          HtmlPageLoaderElement.createFromElement(fixture.rootElement);
      po = HeroDetailPO.create(context);
    });

    test('has empty view', () {
      expect(fixture.rootElement.text.trim(), '');
      expect(po.heroFromDetails, isNull);
    });

    test('transition to ${targetHero['name']} hero', () async {
      await fixture.update((comp) {
        comp.hero = Hero(targetHero['id'], targetHero['name']);
      });
      expect(po.heroFromDetails, targetHero);
    });
  });

  group('${targetHero['name']} initial @Input() hero:', () {
    final Map updatedHero = {'id': targetHero['id']};

    setUp(() async {
      fixture = await testBed.create(
          beforeChangeDetection: (c) =>
              c.hero = Hero(targetHero['id'], targetHero['name']));
      final context =
          HtmlPageLoaderElement.createFromElement(fixture.rootElement);
      po = HeroDetailPO.create(context);
    });

    test('show hero details', () {
      expect(po.heroFromDetails, targetHero);
    });

    test('update name', () async {
      const nameSuffix = 'X';
      updatedHero['name'] = "${targetHero['name']}$nameSuffix";
      await po.type(nameSuffix);
      expect(po.heroFromDetails, updatedHero);
    });

    test('change name', () async {
      const newName = 'Bobbie';
      updatedHero['name'] = newName;
      await po.clear();
      await po.type(newName);
      expect(po.heroFromDetails, updatedHero);
    });
  });
}
