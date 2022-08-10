@TestOn('browser')
import 'package:ngdart/angular.dart';
import 'package:ngrouter/ngrouter.dart';
import 'package:ngtest/angular_test.dart';
import 'package:angular_tour_of_heroes/app_component.dart';
import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;
import 'package:ngpageloader/html.dart';
import 'package:test/test.dart';

import 'app_test.template.dart' as self;
import 'app_po.dart';
import 'utils.dart';

late NgTestFixture<AppComponent> fixture;
late AppPO appPO;
late Router router;

@GenerateInjector(routerProvidersForTesting)
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  // #docregion provisioning-and-setup
  final injector = InjectorProbe(rootInjector);
  final testBed = NgTestBed<AppComponent>(ng.AppComponentNgFactory,
      rootInjector: injector.factory);

  setUp(() async {
    fixture = await testBed.create();
    router = injector.get<Router>(Router);
    await router.navigate('/');
    await fixture.update();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    appPO = AppPO.create(context);
  });
  // #enddocregion provisioning-and-setup

  tearDown(disposeAnyRunningTest);

  group('Basics:', basicTests);
  group('Defaults:', dashboardTests);

  group('Select Heroes:', () {
    setUp(() async {
      await appPO.selectTab(1);
      await fixture.update();
    });

    test('route', () {
      expect(router.current?.path, '/heroes');
    });

    test('tab is showing', () {
      expect(appPO.heroesTabIsActive, isTrue);
    });
  });

  group('Select Dashboard:', () {
    setUp(() async {
      // Navigate away from, then back to the dashboard
      await appPO.selectTab(1);
      await fixture.update();
      await appPO.selectTab(0);
      await fixture.update();
    });

    dashboardTests();
  });

  // #docregion deep-linking
  group('Deep linking:', () {
    test('navigate to hero details', () async {
      await router.navigate('/heroes/11');
      await fixture.update();
      expect(fixture.rootElement.querySelector('my-hero'), isNotNull);
    });

    test('navigate to heroes', () async {
      await router.navigate('/heroes');
      await fixture.update();
      expect(fixture.rootElement.querySelector('my-heroes'), isNotNull);
    });
  });
  // #enddocregion deep-linking
}

void basicTests() {
  test('page title', () {
    expect(appPO.pageTitle, 'Tour of Heroes');
  });

  test('tab titles', () {
    final expectTitles = ['Dashboard', 'Heroes'];
    expect(appPO.tabTitles, expectTitles);
  });
}

void dashboardTests() {
  test('route', () {
    expect(router.current?.path, '/dashboard');
  });

  test('tab is showing', () {
    expect(appPO.dashboardTabIsActive, isTrue);
  });
}
