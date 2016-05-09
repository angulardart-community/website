import 'package:angular2/core.dart';

@Directive(selector: '[myHighlight]', host: const {
  '(mouseenter)': 'onMouseEnter()',
  '(mouseleave)': 'onMouseLeave()'
})
class HighlightDirective {
  String _defaultColor = 'red';
  final dynamic _el;

  HighlightDirective(ElementRef elRef) : _el = elRef.nativeElement;

  @Input()
  set defaultColor(String colorName) {
    _defaultColor = (colorName ?? _defaultColor);
  }

  @Input('myHighlight')
  String highlightColor;

  void onMouseEnter() {
    _highlight(highlightColor ?? _defaultColor);
  }

  void onMouseLeave() {
    _highlight();
  }

  void _highlight([String color]) {
    if (_el != null) _el.style.backgroundColor = color;
  }
}
/*
@Input() String myHighlight;
*/
