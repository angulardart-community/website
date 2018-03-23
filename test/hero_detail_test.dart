@TestOn('browser')

import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/hero.dart';
import 'package:angular_tour_of_heroes/src/hero_component.dart';
import 'package:test/test.dart';

import 'hero_detail_po.dart';
import 'hero_detail_test.template.dart' as ng;

const targetHero = {'id': 1, 'name': 'Alice'};

NgTestFixture<HeroComponent> fixture;
HeroDetailPO po;

void main() {
  ng.initReflector();
  final testBed = new NgTestBed<HeroComponent>();

  tearDown(disposeAnyRunningTest);

  group('No initial @Input() hero:', () {
    setUp(() async {
      fixture = await testBed.create();
      po = await new HeroDetailPO().resolve(fixture);
    });

    test('has empty view', () async {
      expect(fixture.rootElement.text.trim(), '');
      expect(await po.heroFromDetails, isNull);
    });

    test('transition to ${targetHero['name']} hero', () async {
      await fixture.update((comp) {
        comp.hero = new Hero(targetHero['id'], targetHero['name']);
      });
      po = await new HeroDetailPO().resolve(fixture);
      expect(await po.heroFromDetails, targetHero);
    });
  });

  group('${targetHero['name']} initial @Input() hero:', () {
    final Map updatedHero = {'id': targetHero['id']};

    setUp(() async {
      fixture = await testBed.create(
          beforeChangeDetection: (c) =>
              c.hero = new Hero(targetHero['id'], targetHero['name']));
      po = await new HeroDetailPO().resolve(fixture);
    });

    test('show hero details', () async {
      expect(await po.heroFromDetails, targetHero);
    });

    test('update name', () async {
      const nameSuffix = 'X';
      updatedHero['name'] = "${targetHero['name']}$nameSuffix";
      await po.type(nameSuffix);
      expect(await po.heroFromDetails, updatedHero);
    });

    test('change name', () async {
      const newName = 'Bobbie';
      updatedHero['name'] = newName;
      await po.clear();
      await po.type(newName);
      expect(await po.heroFromDetails, updatedHero);
    });
  });
}
