import 'dart:async';

import 'package:pageloader/objects.dart';

class HeroDetailPO extends PageObjectBase {
  @FirstByCss('div h2')
  @optional
  PageLoaderElement get _title => q('div h2'); // e.g. 'Mr Freeze details!'

  @FirstByCss('div div')
  @optional
  PageLoaderElement get _id => q('div div');

  @ByTagName('input')
  @optional
  PageLoaderElement get _input => q('input');

  Future<Map> get heroFromDetails async {
    if (_id == null) return null;
    final idAsString = (await _id.visibleText).split(':')[1];
    final text = await _title.visibleText;
    final matches = new RegExp((r'^(.*) details!$')).firstMatch(text);
    return _heroData(idAsString, matches[1]);
  }

  Future clear() => _input.clear();
  Future type(String s) => _input.type(s);

  Map<String, dynamic> _heroData(String idAsString, String name) =>
      {'id': int.parse(idAsString, onError: (_) => -1), 'name': name};
}
