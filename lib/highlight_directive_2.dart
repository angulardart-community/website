import 'package:angular2/core.dart';

@Directive(selector: '[myHighlight]')
class HighlightDirective {
  final dynamic _el;

  HighlightDirective(ElementRef elRef) : _el = elRef.nativeElement;

  @HostListener('mouseenter')
  void onMouseEnter() {
    _highlight('yellow');
  }

  @HostListener('mouseleave')
  void onMouseLeave() {
    _highlight();
  }

  void _highlight([String color]) {
    if (_el != null) _el.style.backgroundColor = color;
  }
}
