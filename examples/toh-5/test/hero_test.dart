@TestOn('browser')

import 'package:mockito/annotations.dart';
import 'package:ngdart/angular.dart';
import 'package:ngrouter/ngrouter.dart';
import 'package:ngtest/angular_test.dart';
import 'package:angular_tour_of_heroes/src/route_paths.dart';
import 'package:angular_tour_of_heroes/src/hero_component.dart';
import 'package:angular_tour_of_heroes/src/hero_component.template.dart' as ng;
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:mockito/mockito.dart';
import 'package:ngpageloader/html.dart';
import 'package:test/test.dart';

import 'hero_test.template.dart' as self;
import 'hero_po.dart';
import 'utils.dart';

@GenerateNiceMocks([
  MockSpec<Location>(),
  MockSpec<RouterState>(),
])
import 'hero_test.mocks.dart';

late NgTestFixture<HeroComponent> fixture;
late HeroDetailPO po;

@GenerateInjector([
  ClassProvider(HeroService),
  ClassProvider(Location, useClass: MockLocation),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

/// HeroDetail is simple enough that it can be tested without a router.
/// Instead we only mock Location.
void main() {
  final injector = InjectorProbe(rootInjector);
  final testBed = NgTestBed<HeroComponent>(ng.HeroComponentNgFactory,
      rootInjector: injector.factory);

  setUp(() async {
    fixture = await testBed.create();
  });

  tearDown(disposeAnyRunningTest);

  test('No initial hero results in an empty view', () {
    expect(fixture.rootElement.text?.trim(), '');
  });

  const targetHero = {'id': 15, 'name': 'Magneta'};

  group('${targetHero['name']} initial hero:', () {
    final Map updatedHero = <String, dynamic>{'id': targetHero['id']};

    final mockRouterState = MockRouterState();

    when(mockRouterState.parameters)
        .thenReturn({idParam: '${targetHero['id']}'});

    setUp(() async {
      await fixture.update((c) => c.onActivate(null, mockRouterState));
      final context =
          HtmlPageLoaderElement.createFromElement(fixture.rootElement);
      po = HeroDetailPO.create(context);
    });

    test('show hero details', () {
      expect(po.heroFromDetails, targetHero);
    });

    test('updates name', () async {
      const nameSuffix = 'X';
      updatedHero['name'] = "${targetHero['name']}$nameSuffix";
      await po.type(nameSuffix);
      expect(po.heroFromDetails, updatedHero);
    });

    test('back button', () async {
      final mockLocation = injector.get<MockLocation>(Location);
      clearInteractions(mockLocation);
      await po.back();
      verify(mockLocation.back());
    });
  });
}
