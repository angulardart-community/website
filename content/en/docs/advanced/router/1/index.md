---
title: "Routing Basics"
description: "Getting started with the router"
date: 2023-06-23T21:57:48-04:00
draft: false
images: []
menu:
  docs:
    parent: "advanced"
    identifier: "router-1"
weight: 371
toc: true
excerptbase: "router"
---

<!-- {% include_relative _milestone-nav.md  selectedOption="1" %} !-->

For this first milestone, you'll create a rudimentary
version of the app that navigates between two (placeholder) views.

<img class="image-display" src="router-1-anim.gif" alt="App in action" width="282">

## App setup

Create a **new project** named `router_example`, and populate it as described in
[Setup for Development]({{< ref setup >}}).

### Add angular_router

Add the router and forms packages as pubspec dependencies:

{{< alert context="warning" >}}
Versions may be out-of-date. Please use the latest versions according to Pub or
GitHub.
{{< /alert >}}

{{< excerpt src="pubspec.yaml" section="dependencies" >}}

### Add router providers

To tell Angular that your app uses the router,
specify [routerProvidersHash][] in your app's bootstrap function:

{{< excerpt src="web/main.dart" >}}

<!--
{% include location-strategy-callout.md %}

{% comment %}
//- TODO: update the discussion of base-href; see toh. E.g., cover meaningful values when used via WebStorm or when deployed
//- The auto toc generator can't handle  bas href
{% endcomment %}
!-->

<a id="base-href"></a>

### Set the *base href*

Add a [\<base href> element][base] to the app's `index.html`.
The browser uses the `base` `href` value to prefix *relative* URLs when referencing CSS files, scripts, and images.
The router uses the `base` `href` value to prefix *relative* URLs when navigating.

The [starter app]({{< ref toh-0 >}}) sets the `<base>` element dynamically,
so that sample apps built from it can be **run and tested during development** using any
of the [**officially recommended tools**]({{< ref setup >}}#running-the-app):

{{< excerpt src="web/index.html" section="base-href" >}}

For a **production** build, **replace the `<script>`** with a
`<base>` element where the `href` is set to your app's **root path**.
If the path is empty, then use `"/"`:

```html
<head>
  <base href="/">
  ...
</head>
```

You can also statically set the `<base href>` during development.
When serving from the command line, use `href="/"`.
When running apps from WebStorm, use <code>href="<em>my_project</em>/web/"</code>,
where <em>my_project</em> is the name of your project.

```html
<base href="/my_project/web/">
```

<!--
{% comment %}
TODO: also mention appBaseHref?
{% endcomment %}
!-->

### Create crisis and hero list components

Create the following skeletal components under `lib/src`. You'll be using these as router
navigation targets in the next section:

{{< codetabs
    "lib/src/crisis_list_component_1.dart"
    "lib/src/hero_list_component_1.dart"
>}}

## Routes

*Routes* tell the router which views to display when a user clicks a link or
pastes a URL into the browser address bar.

### Route paths

First define a _route path_ ([RoutePath][]) for each
of the app's views:

{{< excerpt src="lib/src/route_paths_1.dart" >}}

{{< alert context="info" >}}
  **Guideline:** By defining route paths in a separate file, you can avoid
  circular dependencies between route definitions in apps with a rich
  navigational structure.
  <!-- {% comment %} See
  https://github.com/dart-lang/angular/edit/master/angular_router/g3doc/migration_guide.md
  {% endcomment %} !-->
{{< /alert >}}

### Route definitions

The router coordinates app navigation based on a list of route defintions.
A route definition ([RouteDefinition][]) associates a route path with a
component. The component is responsible for handling navigation to the path,
and rendering of the associated view.

Define the following routes:

{{< excerpt src="lib/src/routes_1.dart">}}

## *AppComponent* navigation

Next, you'll edit `AppComponent` so that it has
a title,
a navigation bar with two links, and
a *router outlet* where the router swaps views on and off the page.
This is what it will look like:

{{< figure src="shell-and-outlet.png" alt="Shell" width="332" >}}

Update the `AppComponent` code to the following:

{{< excerpt src="lib/app_component_1.dart" >}}

<a id="router-directives"></a>
### *RouterOutlet*

[RouterOutlet][] is one of the **[routerDirectives.][routerDirectives]**
To use a router directive like `RouterOutlet` within a
component, add it individually to the component's `directives` list,
or for convenience you can add the [routerDirectives][] list:

<!-- TODO: use new docregion instead of the ugly regex
{{< excerpt src="lib/app_component_1.dart" section="template-and-directives" >}}
!-->
```dart
  template: '''
    ...
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''',
  directives: [routerDirectives],
```

In the DOM, the router diplays views (for the routes bound to the `routes`
[input property][property binding]) by inserting view elements as siblings
immediately _after_ `<router-outlet>`.

### *RouterLink*s {#router-link}

Above the outlet, within anchor tags, you see
[property bindings][property binding] to [RouterLink][] directives.
Each router link is bound to a route path.

{{< excerpt src="lib/app_component_1.dart" section="template" >}}

Set the [RouterLink][] `routerLinkActive` property to the CSS class
that the router will apply to the element when its route is active.

<!-- TODO: same as above, use more granular docregion
{{< excerpt src="lib/app_component_1.dart" section="template" >}} !-->
```dart
  template: '''...
      <a [routerLink]="RoutePaths.crises.toUrl()"
         [routerLinkActive]="'active-route'">Crisis Center</a>
      <a [routerLink]="RoutePaths.heroes.toUrl()"
         [routerLinkActive]="'active-route'">Heroes</a>
  ...''',
  styles: ['.active-route {color: #039be5}'],
```

<a id="wrap-up"></a>
## App code

You've got a very basic, navigating app, one that can switch between two views
when the user clicks a link. The app's structure looks like this:

<div class="ul-filetree">
{{< markdownify >}}
- router_example
  - lib
    - app_component.dart
    - src
      - crisis_list_component.dart
      - hero_list_component.dart
      - route_paths.dart
      - routes.dart
  - web
    - index.html
    - main.dart
    - styles.css
{{< /markdownify >}}
</div>

Here are the files discussed in this milestone

{{< codetabs
    "lib/app_component_1.dart"
    "lib/src/route_paths_1.dart"
    "lib/src/routes_1.dart"
    "lib/src/crisis_list_component_1.dart"
    "lib/src/hero_list_component_1.dart"
    "web/index.html"
    "web/main.dart"
>}}

[base]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base
[property binding]: {{< ref template-syntax >}}#property-binding
[routerDirectives]: {{< param pubApi >}}/ngrouter/latest/angular_router/routerDirectives-constant.html
[routerProviders]: {{< param pubApi >}}/ngrouter/latest/angular_router/routerProviders-constant.html
[routerProvidersHash]: {{< param pubApi >}}/ngrouter/latest/angular_router/routerProvidersHash-constant.html
[RouteDefinition]: {{< param pubApi >}}/ngrouter/latest/angular_router/RouteDefinition-class.html
[RouterLink]: {{< param pubApi >}}/ngrouter/latest/angular_router/RouterLink-class.html
[RouterOutlet]: {{< param pubApi >}}/ngrouter/latest/angular_router/RouterOutlet-class.html
[RoutePath]: {{< param pubApi >}}/ngrouter/latest/angular_router/RoutePath-class.html
