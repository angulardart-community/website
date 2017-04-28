import 'package:angular2/core.dart';

@Directive(selector: '[myHighlight]')
class HighlightDirective {
  final ElementRef _el;

  HighlightDirective(this._el);

  @Input()
  String defaultColor;

  @Input('myHighlight')
  String highlightColor;

  @HostListener('mouseenter')
  void onMouseEnter() => _highlight(highlightColor ?? defaultColor ?? 'red');

  @HostListener('mouseleave')
  void onMouseLeave() => _highlight();

  void _highlight([String color]) {
    _el.nativeElement.style.backgroundColor = color;
  }
}
