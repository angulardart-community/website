@TestOn('browser')
import 'package:angular_test/angular_test.dart';
import 'package:lifecycle_hooks/app_component.template.dart' as ngapp;
import 'package:lifecycle_hooks/src/peek_a_boo_parent_component.template.dart' as ngpeek;
import 'package:test/test.dart';

void main() {
  tearDown(disposeAnyRunningTest);

  test('should open correctly', () async {
    final testBed = NgTestBed(ngapp.AppComponentNgFactory);
    final fixture = await testBed.create();
    expect(fixture.rootElement.querySelector('h2')?.text, 'Peek-A-Boo');
  });

  test('should support peek-a-boo', () async {
    final testBed = NgTestBed(ngpeek.PeekABooParentComponentNgFactory);
    final fixture = await testBed.create();
    var pabComp = fixture.rootElement.querySelector('peek-a-boo');
    expect(pabComp, isNull, reason: 'should not be able to find the "peek-a-boo" component');
    final pabButton = fixture.rootElement.querySelector('button');
    expect(pabButton?.text, contains('Create Peek'));
    pabButton?.click();
    await fixture.update();
    expect(pabButton?.text, contains('Destroy Peek'));
    pabComp = fixture.rootElement.querySelector('peek-a-boo');
    expect(pabComp, isNotNull, reason: 'should be able to see the "peek-a-boo" component');
    expect(pabComp?.text, contains('Windstorm'));
    expect(pabComp?.text, isNot(contains('Windstorm!')));
    var updateHeroButton = fixture.rootElement.querySelectorAll('button')[1];
    expect(updateHeroButton, isNotNull, reason: 'should be able to see the update hero button');
    updateHeroButton.click();
    await fixture.update();
    expect(pabComp?.text, contains('Windstorm!'));
    pabButton?.click();
    await fixture.update();
    expect(pabComp, isNotNull, reason: 'should no longer be able to find the "peek-a-boo" component');
  });
}
