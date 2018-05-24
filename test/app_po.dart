import 'dart:async';

import 'package:pageloader/pageloader.dart';

part 'app_po.g.dart';

@PageObject()
abstract class AppPO {
  AppPO();
  factory AppPO.create(PageLoaderElement context) = $AppPO.create;

  @ByTagName('h1')
  PageLoaderElement get _title;

  @First(ByCss('div'))
  PageLoaderElement get _id; // e.g. 'id: 1'

  @ByTagName('h2')
  PageLoaderElement get _heroName;

  @ByTagName('input')
  PageLoaderElement get _input;

  String get title => _title.visibleText;

  int get heroId {
    final idAsString = _id.visibleText.split(':')[1];
    return int.tryParse(idAsString) ?? -1;
  }

  String get heroName => _heroName.visibleText;

  Future<void> type(String s) => _input.type(s);
}
