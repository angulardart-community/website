@TestOn('browser')

import 'package:ngdart/angular.dart';
import 'package:ngrouter/ngrouter.dart';
import 'package:ngtest/angular_test.dart';
import 'package:angular_tour_of_heroes/src/hero_list_component.dart';
// #docregion providers-with-context, rootInjector
import 'package:angular_tour_of_heroes/src/hero_list_component.template.dart'
    as ng;
// #enddocregion rootInjector
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:angular_tour_of_heroes/src/route_paths.dart';
import 'package:mockito/mockito.dart';
import 'package:ngpageloader/html.dart';
import 'package:test/test.dart';

// #docregion rootInjector
import 'heroes_test.template.dart' as self;
// #enddocregion rootInjector
import 'heroes_po.dart';
import 'utils.dart';

late NgTestFixture<HeroListComponent> fixture;
late HeroesPO po;

// #docregion rootInjector
@GenerateInjector([
  ClassProvider(HeroService),
  ClassProvider(Router, useClass: MockRouter),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  final injector = InjectorProbe(rootInjector);
  final testBed = NgTestBed<HeroListComponent>(
    ng.HeroListComponentNgFactory,
    rootInjector: injector.factory,
  );
  // #enddocregion rootInjector

  setUp(() async {
    fixture = await testBed.create();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    po = HeroesPO.create(context);
  });

  tearDown(disposeAnyRunningTest);
  // #enddocregion providers-with-context

  group('Basics:', basicTests);
  group('Selected hero:', () => selectedHeroTests(injector));
  // #docregion providers-with-context, rootInjector
}
// #enddocregion providers-with-context, rootInjector

void basicTests() {
  test('title', () {
    expect(po.title, 'Heroes');
  });

  test('hero count', () {
    expect(po.heroes.length, 10);
  });

  test('no selected hero', () {
    expect(po.selected, null);
  });
}

// #docregion go-to-detail
void selectedHeroTests(InjectorProbe injector) {
  const targetHero = {'id': 15, 'name': 'Magneta'};

  setUp(() async {
    await po.selectHero(4);
  });

  // #enddocregion go-to-detail
  test('is selected', () {
    expect(po.selected, targetHero);
  });

  test('show mini-detail', () {
    expect(po.myHeroNameInUppercase,
        equalsIgnoringCase(targetHero['name'] as String));
  });

  // #docregion go-to-detail
  test('go to detail', () async {
    await po.gotoDetail();
    final mockRouter = injector.get<MockRouter>(Router);
    final c = verify(mockRouter.navigate(captureAny));
    expect(c.captured.single,
        RoutePaths.hero.toUrl(parameters: {idParam: '${targetHero['id']}'}));
  });
  // #enddocregion go-to-detail

  test('select another hero', () async {
    await po.selectHero(0);
    final heroData = {'id': 11, 'name': 'Mr. Nice'};
    expect(await po.selected, heroData);
  });
  // #docregion go-to-detail
}
