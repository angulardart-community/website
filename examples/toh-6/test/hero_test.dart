@TestOn('browser')

import 'package:mockito/annotations.dart';
import 'package:ngdart/angular.dart';
import 'package:ngrouter/ngrouter.dart';
import 'package:ngtest/ngtest.dart';
import 'package:angular_tour_of_heroes/src/route_paths.dart';
import 'package:angular_tour_of_heroes/in_memory_data_service.dart';
import 'package:angular_tour_of_heroes/src/hero_component.dart';
import 'package:angular_tour_of_heroes/src/hero_component.template.dart' as ng;
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:ngpageloader/html.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([
  MockSpec<Location>(),
  MockSpec<RouterState>(),
])
import 'hero_test.mocks.dart';

import 'hero_test.template.dart' as self;
import 'hero_po.dart';
import 'utils.dart';

late NgTestFixture<HeroComponent> fixture;
late HeroDetailPO po;

@GenerateInjector([
  ClassProvider(Client, useClass: InMemoryDataService),
  ClassProvider(HeroService),
  ClassProvider(Location, useClass: MockLocation),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  final injector = InjectorProbe(rootInjector);
  final testBed = NgTestBed<HeroComponent>(ng.HeroComponentNgFactory,
      rootInjector: injector.factory);

  setUp(() async {
    fixture = await testBed.create();
    InMemoryDataService.resetDb();
  });

  tearDown(disposeAnyRunningTest);

  test('No initial hero results in an empty view', () {
    expect(fixture.rootElement.text?.trim(), '');
  });

  const targetHero = {'id': 15, 'name': 'Magneta'};

  group('${targetHero['name']} initial hero:', () {
    const nameSuffix = 'X';
    final Map updatedHero = <String, dynamic>{
      'id': targetHero['id'],
      'name': "${targetHero['name']}$nameSuffix"
    };

    final mockRouterState = MockRouterState();
    when(mockRouterState.parameters)
        .thenReturn({idParam: '${targetHero['id']}'});
    late MockLocation mockLocation;

    setUp(() async {
      mockLocation = injector.get<MockLocation>(Location);
      await fixture.update((c) => c.onActivate(null, mockRouterState));
      final context =
          HtmlPageLoaderElement.createFromElement(fixture.rootElement);
      po = HeroDetailPO.create(context);
      clearInteractions(mockLocation);
    });

    test('show hero details', () {
      expect(po.heroFromDetails, targetHero);
    });

    test('back button', () async {
      await po.back();
      verify(mockLocation.back());
    });

    group('Update name:', () {
      setUp(() async {
        await po.type(nameSuffix);
      });

      test('show updated name', () {
        expect(po.heroFromDetails, updatedHero);
      });

      test('discard changes', () async {
        await po.back();
        final name = InMemoryDataService.lookUpName(targetHero['id'] as int);
        expect(name, targetHero['name']);
      });

      test('save changes and go back', () async {
        await po.save();
        await fixture.update();
        final name = InMemoryDataService.lookUpName(targetHero['id'] as int);
        expect(name, updatedHero['name']);
      });
    });
  });
}
