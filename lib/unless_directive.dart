import 'package:angular2/core.dart';

@Directive(selector: '[myUnless]')
class UnlessDirective {
  TemplateRef _templateRef;
  ViewContainerRef _viewContainer;

  UnlessDirective(this._templateRef, this._viewContainer);

  @Input()
  set myUnless(bool condition) {
    if (!condition) {
      _viewContainer.createEmbeddedView(_templateRef);
    } else {
      _viewContainer.clear();
    }
  }
}
