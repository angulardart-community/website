import 'package:angular2/core.dart';

@Directive(selector: '[myHighlight]')
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

  @HostListener('mouseenter')
  void onMouseEnter() => _highlight(highlightColor ?? _defaultColor);

  @HostListener('mouseleave')
  void onMouseLeave() => _highlight();

  void _highlight([String color]) {
    if (_el != null) _el.style.backgroundColor = color;
  }
}
/*
@Input() String myHighlight;
*/
