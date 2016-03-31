import 'package:angular2/core.dart';

@Directive(selector: '[my-highlight]', host: const {
  '(mouseenter)': 'onMouseEnter()',
  '(mouseleave)': 'onMouseLeave()'
})
class Highlight {
  /*
  @Input() myHighlight: string;
  */
  @Input('my-highlight')
  String highlightColor;

  String _defaultColor = 'red';
  @Input()
  set defaultColor(String colorName) {
    _defaultColor = (colorName ?? _defaultColor);
  }

  final ElementRef _element;

  onMouseEnter() {
    _highlight(highlightColor ?? _defaultColor);
  }

  onMouseLeave() {
    _highlight(null);
  }

  void _highlight(String color) {
    _element.nativeElement.style.backgroundColor = color;
  }

  Highlight(this._element);
}
