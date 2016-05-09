import 'package:angular2/core.dart';

@Directive(selector: '[myHighlight]', host: const {
  '(mouseenter)': 'onMouseEnter()',
  '(mouseleave)': 'onMouseLeave()'
})
class HighlightDirective {
  final dynamic _el;

  HighlightDirective(ElementRef elRef) : _el = elRef.nativeElement;

  void onMouseEnter() {
    _highlight("yellow");
  }

  void onMouseLeave() {
    _highlight();
  }

  void _highlight([String color]) {
    if (_el != null) _el.style.backgroundColor = color;
  }
}
