import 'dart:convert';
import 'dart:html';

import 'package:angular2/angular2.dart';

@Pipe(name: 'fetch', pure: false)
class FetchJsonPipe extends PipeTransform {
  dynamic _fetchedJson;
  String _prevUrl;

  dynamic transform(dynamic url, [List<dynamic> args]) {
    if (url != _prevUrl) {
      _prevUrl = url;
      _fetchedJson = null;
      HttpRequest.getString(url).then((s) {
        _fetchedJson = JSON.decode(s);
      });
    }
    return _fetchedJson;
  }
}
