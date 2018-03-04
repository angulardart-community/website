import 'dart:async';

import 'package:pageloader/objects.dart';

class AppPO extends PageObjectBase {
  @ByTagName('h1')
  PageLoaderElement get _pageTitle => q('h1');

  @FirstByCss('h2')
  PageLoaderElement get _tabTitle => q('h2');

  @ByTagName('li')
  List<PageLoaderElement> get _heroes => qq('li');

  @ByTagName('li')
  @WithClass('selected')
  @optional
  PageLoaderElement get _selectedHero => q('li.selected');

  @FirstByCss('div h2')
  @optional
  PageLoaderElement get _heroDetailHeading =>
      q('div h2'); // e.g. 'Mr Freeze details!'

  @FirstByCss('div div')
  @optional
  PageLoaderElement get _heroDetailId => q('div div');

  @ByTagName('input')
  @optional
  PageLoaderElement get _input => q('input');

  Future<String> get pageTitle => _pageTitle.visibleText;
  Future<String> get tabTitle => _tabTitle.visibleText;

  Iterable<Future<Map>> get heroes =>
      _heroes.map((el) async => _heroDataFromLi(await el.visibleText));

  Future selectHero(int index) => _heroes[index].click();

  Future<Map> get selectedHero async => _selectedHero == null
      ? null
      : _heroDataFromLi(await _selectedHero.visibleText);

  Future<Map> get heroFromDetails async {
    if (_heroDetailId == null) return null;
    final idAsString = (await _heroDetailId.visibleText).split(':')[1];
    final text = await _heroDetailHeading.visibleText;
    final matches = new RegExp((r'^(.*) details!$')).firstMatch(text);
    return _heroData(idAsString, matches[1]);
  }

  Future clear() => _input.clear();
  Future type(String s) => _input.type(s);

  Map<String, dynamic> _heroData(String idAsString, String name) =>
      {'id': int.parse(idAsString, onError: (_) => -1), 'name': name};

  Map<String, dynamic> _heroDataFromLi(String liText) {
    final matches = new RegExp((r'^(\d+) (.*)$')).firstMatch(liText);
    return _heroData(matches[1], matches[2]);
  }
}
