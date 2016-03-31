import 'package:angular2/core.dart';

@Directive(selector: '[my-highlight]', host: const {
  '(mouseenter)': 'onMouseEnter()',
  '(mouseleave)': 'onMouseLeave()'
})
class Highlight {
  final ElementRef _element;
  onMouseEnter() {
    _highlight("yellow");
  }

  onMouseLeave() {
    _highlight(null);
  }

  void _highlight(String color) {
    _element.nativeElement.style.backgroundColor = color;
  }

  Highlight(this._element);
}
