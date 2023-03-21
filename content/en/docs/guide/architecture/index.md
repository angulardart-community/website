---
title: Architecture Overview
description: The basic building blocks of Angular apps.
draft: false
menu:
  docs:
    parent: "guide"
weight: 130
toc: true
excerptbase: architecture
---
<style>img.image-display {
  box-shadow: none;
  padding: 0;
  margin: 8px 0 8px 0;
}
.image-left {
  float: left;
  margin-right: 10px;
}
.guide-architecture-fix-overflow { overflow: hidden; }
</style>

AngularDart (which we usually call simply Angular in this documentation)
is a framework for building client apps in HTML and Dart.
It is published as the
[**ngdart**]({{< param pubPkg >}}/ngdart) package, which
is available via the Pub tool.

You write Angular apps by composing HTML *templates* with Angularized
markup, writing *component* classes to manage those templates, adding
application logic in *services*, and boxing components and services in
*modules*.

After you launch the app,
Angular takes over, presenting your app content in a browser and
responding to user interactions according to the instructions you've provided.

Of course, there is more to it than this.
You'll learn the details in the pages that follow. For now, focus on the big
picture.

{{< figure src="overview2.png" alt="overview" caption="overview" width="700" >}}

The architecture diagram identifies the eight main building blocks of an Angular
app:

* [Modules](#modules)
* [Components](#components)
* [Templates](#templates)
* [Metadata](#metadata)
* [Data binding](#data-binding)
* [Directives](#directives)
* [Services](#services)
* [Dependency injection](#dependency-injection)

{{< alert context="info" raw=true >}}
The code referenced on this page is available as a {{< exref architecture >}}.
{{< /alert >}}

## Modules

{{< figure src="module.png" class="image-left" alt="Modules" width="150">}}

Angular apps are modular; that is, apps are assembled from many
**modules**.

In this guide, the term **_module_** refers to a Dart compilation unit, such
as a library, or a package. If a Dart file has no `library` or `part`
directive, then that file itself is a library and thus a compilation
unit. For more information about compilation units, see
the chapter on "Libraries and Scripts" in the
[Dart Language Specification]({{< param dartlang >}}/guides/language/spec).
<br class="l-clear-both">

Every Angular app has at least one module, the _root module_.
While the _root module_ may be the only module in a small app,
most apps have many more _feature modules_,
each a cohesive block of code dedicated to an application domain,
a workflow, or a closely related set of capabilities.

The simplest of root modules defines a single _root_
[**component**](#components) class such as this one:

{{< excerpt src="lib/app_component.dart" section="class" >}}

By convention, the name of the root component is `AppComponent`.

### Angular libraries

{{< figure src="library-module.png" class="image-left" alt="Libraries"
width="200">}}

Angular ships as a collection of libraries within the
[**angular**](https://pub.dev/packages/angular) package.
The main Angular library is [angular]({{site.api}}?package=angular),
which most app modules import as follows:

{{< excerpt src="lib/app_component.dart" section="import" >}}

<!-- TODO: sorry, not yet!
The angular package includes other important libraries, such as
[angular.security]({{site.pub-api}}/angular/{{site.data.pkg-vers.angular.vers}}/angular.security/angular.security-library.html). -->

<div class="l-hr"></div>

## Components

{{< figure src="hero-component.png" class="image-left" alt="Component"
width="200" >}}

<div class="guide-architecture-fix-overflow" markdown="1">
  A _component_ controls a patch of screen called a *view*.

  For example, the following views are controlled by components:

  * The app root with the navigation links.
  * The list of heroes.
  * The hero editor.
</div>

You define a component's application logic&mdash;what it does to support the
view&mdash;inside a class. The class interacts with the view through an API of
properties and methods.

<a id="component-code"></a>
In the following example, the `HeroListComponent` has a `heroes` property that
returns a list of heroes that it acquires from a service.
`HeroListComponent` defines a `selectHero()` method that sets a `selectedHero`
property when the user clicks to choose a hero from the list.

{{< excerpt src="lib/src/hero_list_component.dart" section="class" >}}

Angular creates, updates, and destroys components as the user moves through the
app. Your app can take action at each moment in this lifecycle through optional
[lifecycle hooks](lifecycle-hooks), like `ngOnInit()` declared above.

<div class="l-hr"></div>

## Templates

{{< figure src="template.png" class="image-left" alt="Template" width="200" >}}

You define a component's view with its companion **template**. A template is a
special form of HTML that tells Angular how to render the component. We call it
"special" because it's not any ordinary HTML... Angular provides all sorts
of features to make writing these templates fun and fast!

A template looks like regular HTML, except for a few differences. Here is a
template for the example `HeroListComponent`:

{{< excerpt src="lib/src/hero_list_component.html" lang="html">}}

The template uses typical HTML elements like `<h2>` and  `<p>`. It also
includes code that uses Angular's [template syntax]({{ ref template-syntax }}) like
`*ngFor`, `{{hero.name}}`, `(click)`, `[hero]`, and `<hero-detail>`.

In the last line of the template, the `<hero-detail>` tag is a custom element
that represents a new component, `HeroDetailComponent`. The new component (code
not shown) presents facts about the hero that the user selects from the list
presented by the `HeroListComponent`. The `HeroDetailComponent` is a **child**
of the `HeroListComponent`.

{{< figure src="component-tree.png" class="image-left" alt="Metadata"
width="300" >}}

Notice how `<hero-detail>` rests comfortably among native HTML elements. You can
mix custom components with native HTML in the same layouts.
<br class="l-clear-both">

<!-- TODO: the below l-hr class provides a divier, which should remove the need
for the staggering amount of br's here. -->
</br>
</br>
</br>
</br>
</br>
</br>

<div class="l-hr"></div>

## Metadata

{{< figure src="metadata.png" class="image-left" alt="Metadata" width="150" >}}

Metadata tells Angular how to process a class.<br class="l-clear-both">

[Looking back at the code](#component-code) for `HeroListComponent`, you can see
that it's just a class. There is no evidence of a framework, no Angular-specific
code.

In fact, `HeroListComponent` really is *just a class*. It's not a component
until you tell Angular about it. To tell Angular that `HeroListComponent` is a
component, attach **metadata** to the class. In Dart, you attach metadata by
using an **annotation**.

Here's some metadata for `HeroListComponent`. The `@Component` annotation
identifies the class immediately below it as a component class:

{{< excerpt src="lib/src/hero_list_component.dart" section="metadata" >}}

The `@Component` annotation accepts parameters supplying the
information Angular needs to create and present the component and its view.

The example `HeroListComponent` uses the following `@Component` parameters:

- `selector`: a CSS selector that tells Angular to create and insert an instance
  of this component where it finds a `<hero-list>` tag in *parent* HTML.
  For example, if an app's  HTML contains `<hero-list></hero-list>`, then
  Angular inserts an instance of the `HeroListComponent` view between those
  tags.

- `templateUrl`: the module-relative address of this component's HTML template,
  shown [above](#templates).

- `directives`: a list of the components or directives that this template
  requires. For Angular to process app tags that appear in a template, like
  `<hero-detail>`, you must declare the tag's corresponding component in the
  `directives` list.

- `providers`: a list of **dependency injection providers** for services that
  the component requires. This is one way to tell Angular that the component's
  constructor requires a `HeroService` so it can get the list of heroes to
  display.

{{< figure src="template-metadata-component.png" class="image-left" alt="Metadata" width="115" >}}

The metadata in the `@Component` tells Angular where to get the major building
blocks you specify for the component.

The template, metadata, and component together describe a view.

Apply other metadata annotations in a similar fashion to guide Angular behavior.
`@Input` and `@Output` are two of the more popular annotations.
<br class="l-clear-both">

The architectural takeaway is that you must add metadata to your code
so that Angular knows what to do.

<!-- Remove <br/> here -->
<br/>

<div class="l-hr"></div>

## Data binding

Without a framework, you're responsible for pushing data values into the HTML
controls and turning user responses into actions and value updates. Writing such
push/pull logic by hand is tedious and error prone, and the result is often
difficult to read.

{{< figure src="databinding.png" class="image-left" alt="Data Binding" width="250" >}}

Angular supports **data binding**, a mechanism for coordinating parts of a
template with parts of a component. Add binding markup to the template HTML to
tell Angular how to connect the template and the component.

As the diagram shows, there are four forms of data binding syntax. Each form has
a direction: to the DOM, from the DOM, or in both directions.

<!-- Remove <br/> here, use the l-clear-both -->
<br/>

<br class="l-clear-both">

The `HeroListComponent` [example](#templates) template includes three of the
four forms of data binding syntax:

{{< excerpt src="lib/src/hero_list_component_1.html" section="binding" 
lang="html" >}}

Here are the three ways that the example uses data binding syntax:

* The `{{hero.name}}` [*interpolation*](displaying-data#interpolation)
  displays the component's `hero.name` property value within the `<li>`
  element.

* The `[hero]` [*property binding*](template-syntax#property-binding)
  passes the value of `selectedHero` from the parent `HeroListComponent` to the
  `hero` property of the child `HeroDetailComponent`.

* The `(click)` [*event binding*](user-input#click) calls the component's
  `selectHero` method when the user clicks a hero's name.

The fourth form of data binding is
[*two-way data binding*](template-syntax#two-way).
Two-way binding combines property and event binding in a single
notation, using the `ngModel` directive.
In two-way binding, a data property value flows to the input box from the
component as with property binding. The user's changes also flow back to the
component, resetting the property to the latest value, as with event binding.

Here's an example of two-way binding from the `HeroDetailComponent` template:

{{< excerpt src="lib/src/hero_detail_component.html" section="ngModel"
lang="html" >}}

Angular processes all data bindings once per JavaScript event cycle,
from the root of the app component tree through all child components.

{{< figure src="component-databinding.png" class="image-left" alt="Data Binding" width="300">}}

Data binding plays an important role in communication between a template and its
component.

<!-- TODO: remove </br> -->
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

<br class="l-clear-both">

{{< figure src="parent-child-binding.png" class="image-left" alt="Parent/Child binding" width="300" >}}

Data binding is also important for communication between parent and child
components.
<br class="l-clear-both">

<!-- TODO: remove </br> -->
<br/>
<br/>
<br/>
<br/>

<div class="l-hr"></div>

## Directives

{{< figure src="directive.png" class="image-left" alt="Parent child" width="150">}}

Angular templates are *dynamic*. When Angular renders them, it transforms the
DOM according to the instructions given by **directives**.

A directive is a class with a `@Directive` annotation. A component is a
*directive with a template*; a `@Component` annotation is actually a
`@Directive` annotation extended with template-oriented features.
<br class="l-clear-both">

<div class="l-sub-section" markdown="1">
  While **a component is technically a directive**, this architectural overview
  separates components from directives because components are a distinctive
  part of, and central to, Angular apps.
</div>

Two *other* kinds of directives exist: _structural_ and _attribute_ directives.

They tend to appear within an element tag in the same way as attributes,
sometimes specified by name but more often as the target of an assignment or a
binding.

**Structural** directives alter layout by adding, removing, and replacing
elements in the DOM.

The [example template](#templates) uses two built-in structural directives:

{{< excerpt src="lib/src/hero_list_component_1.html" section="structural" >}}

* [`*ngFor`](displaying-data#ngFor) tells Angular to stamp out one
  `<li>` per hero in the `heroes` list.
* [`*ngIf`](displaying-data#ngIf) includes the `HeroDetail` component only
  if a selected hero exists.

{{< alert context="warning" >}}
  In Dart, **the only value that is true is the boolean value `true`**; all
  other values are false. JavaScript and TypeScript, by contrast, treat values
  such as 1 and most non-null objects as true. For this reason, the JavaScript
  and TypeScript versions of this app can use just `selectedHero` as the value
  of the `*ngIf` expression. The Dart version must use a boolean operator such
  as `!=` instead.
{{< /alert >}}

**Attribute** directives alter the appearance or behavior of an existing
element. In templates they look like regular HTML attributes, hence the name.

The `ngModel` directive, which implements two-way data binding, is
an example of an attribute directive. `ngModel` modifies the behavior of
an existing element (typically an `<input>`)
by setting its display value property and responding to change events.

{{< excerpt src="lib/src/hero_detail_component.html" section="ngModel" >}}

Angular has a few more directives that either alter the layout structure
(for example, [ngSwitch](template-syntax#ngSwitch))
or modify aspects of DOM elements and components
(for example, [ngStyle](template-syntax#ngStyle) and
[ngClass](template-syntax#ngClass)).

You can also write your own directives. Components such as
`HeroListComponent` are one kind of custom directive.
[Custom structural directives](structural-directives#unless)
are another.


<div class="l-hr"></div>

## Services

{{< figure src="service.png" class="image-left" alt="Service" width="150" >}}

_Service_ is a broad category encompassing any value, function, or feature that your app needs.

Almost anything can be a service. A service is typically a class with a narrow,
well-defined purpose. It should do something specific and do it well.
<br class="l-clear-both">

Examples include:
* logging service
* data service
* message bus
* tax calculator
* app configuration

There is nothing specifically _Angular_ about services. Angular has no
definition of a service. There is no service base class, and no place to
register a service. Yet services are fundamental to any Angular app. Components
are big consumers of services.

Here's an example of a service class that logs to the browser console:

{{< excerpt src="lib/src/logger_service.dart" section="class">}}

Here's a `HeroService` that uses a [Future][] to fetch heroes.
The `HeroService` depends on the `Logger` service and another `BackendService`
that handles the server communication grunt work.

{{< excerpt src="lib/src/hero_service.dart" section="class">}}

Services are everywhere.

Component classes should be lean. They don't fetch data from the server,
validate user input, or log directly to the console.
A component's job is to enable the user experience and nothing more. It mediates
between the view (rendered by the template)
and the application logic (which often includes some notion of a _model_).
A good component presents properties and methods for data binding.
It delegates everything nontrivial to services.

Angular doesn't *enforce* these principles.
It doesn't complain if you write a component with 3000 lines of code that does
everything in your app.

Angular does help you *follow* these principles by making it easy to factor your
application logic into services and make those services available to components
through *dependency injection*.

<div class="l-hr"></div>

## Dependency injection

{{< figure src="dependency-injection.png" class="image-left" alt="Dependency Injection" width="200" >}}

_Dependency injection_ is a way to supply a new instance of a class
with the fully-formed dependencies it requires. Most dependencies are services.
Angular uses dependency injection to provide new components with the services
they need.
<br class="l-clear-both">

Angular can tell which services a component needs by looking at the types of its
constructor parameters. For example, the constructor of the example
`HeroListComponent` needs a `HeroService`:

{{< excerpt src="lib/src/hero_list_component.dart" section="ctor" >}}

When Angular creates a component, it first asks an **injector** for
the services that the component requires. An injector maintains a container of
service instances that it has previously created.
If a requested service instance is not in the container, the injector makes one
and adds it to the container before returning the service to Angular.
When all requested services have been resolved and returned,
Angular can call the component's constructor with those services as arguments.
This is *dependency injection*.

The process of `HeroService` injection looks a bit like this:

{{< figure src="injector-injects.png" alt="Service" >}}

If the injector doesn't have a `HeroService`, how does it know how to make one?

In brief, you must register a **provider** of the `HeroService` with the
injector. A provider can create or return a service, and is often the service
class itself.

You can register providers with a _component_, or through the _root injector_
when the app is launched.

### Registering providers with a component

The most common way to register providers is at the component level using the
`providers` argument of the `@Component` annotation:

{{< excerpt src="lib/app_component.dart" section="providers" >}}

Registering the provider with a component means you get a new instance of the
service with each new instance of that component. A service provided through a
component is shared with all of the component's descendants in the app component
tree.

### Registering providers with the root injector

Registering providers with the root injector is much less common.
For details, see the [registering a service provider][] section of
[Dependency Injection][].

[Dependency Injection]: dependency-injection
[registering a service provider]: dependency-injection#injector-config

Points to remember about dependency injection:

* Dependency injection is wired into the Angular framework and used everywhere.

* The *injector* is the main mechanism.
  * An injector maintains a *container* of the service instances that it
    created.
  * An injector can create a new service instance from a *provider*.

* A *provider* is a recipe for creating a service.

* You register *providers* with injectors.

<div class="l-hr"></div>

## Wrapup

You've learned the basics about the eight main building blocks of an Angular
app:

* [Modules](#modules)
* [Components](#components)
* [Templates](#templates)
* [Metadata](#metadata)
* [Data binding](#data-binding)
* [Directives](#directives)
* [Services](#services)
* [Dependency injection](#dependency-injection)

That's a foundation for everything else in an Angular app,
and it's more than enough to get going.
But it doesn't include everything you need to know.

Here is a brief, alphabetical list of other important Angular features and services.

- [**Forms**]({{< ref forms >}}): Support complex data entry scenarios with HTML-based
  validation and dirty checking.

- [**HTTP**]({{< ref server-communication >}}): Communicate with a server to get data, save
  data, and invoke server-side actions with an HTTP client.

- [**Lifecycle hooks**]({{< ref lifecycle-hooks >}}): Tap into key moments in the lifetime
  of a component, from its creation to its destruction,
  by implementing the lifecycle hook interfaces.

- [**Pipes**]({{< ref pipes >}}): Improve the user experience by transforming values for
  display.

- [**Router**]({{< ref router >}}): Navigate from page to page within the client app and
  never leave the browser.

- [**Testing**]({{< ref testing >}}): Write component tests and end-to-end tests for your
  app.

[Future]: {{< param dartApi >}}/stable/dart-async/Future-class.html
