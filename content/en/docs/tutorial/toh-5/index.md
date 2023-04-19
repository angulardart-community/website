---
title: "5. Routing"
description: "Add the Angular component router and learn to navigate among the views."
lead: ""
date: 2023-03-09T22:20:36-05:00
lastmod: 2023-03-09T22:20:36-05:00
draft: false
images: []
menu:
  docs:
    parent: "tutorial"
    identifier: "toh-5"
weight: 260
toc: true
excerptbase: "toh-5"
---

There are new requirements for the Tour of Heroes app:

* Add a *Dashboard* view.
* Add the ability to navigate between the *Heroes* and *Dashboard* views.
* When users click a hero name in either view, navigate to a detail view of the selected hero.
* When users click a *deep link* in an email, open the detail view for a particular hero.

When you’re done, users will be able to navigate the app like this:

{{< figure src="nav-diagram.png" alt="View navigations" >}}

To satisfy these requirements, you'll add Angular’s router to the app.

{{< alert context="info" >}}
  For more information about the router, read the [Routing and Navigation]({{< ref router >}}) page.
{{< /alert >}}

When you're done with this page, the app should look like this {{< exref toh-5 >}}.

<!-- {%comment%}include ../../../_includes/_see-addr-bar{%endcomment%} -->

## Where you left off

Before continuing with the Tour of Heroes, verify that you have the following structure.

<div class="ul-filetree">
{{< markdownify >}}
- angular_tour_of_heroes
  - lib
    - app_component.{css,dart,html}
    - src
      - hero.dart
      - hero_component.dart
      - hero_service.dart
      - mock_heroes.dart
  - test
    - ...
  - web
    - index.html
    - main.dart
    - styles.css
  - analysis_options.yaml
  - pubspec.yaml
{{< /markdownify >}}
</div>


## Action plan

Here's the plan:

* Turn `AppComponent` into an app shell that only handles navigation.
* Relocate the *Heroes* concerns within the current `AppComponent` to a separate `HeroListComponent`.
* Add routing.
* Create a new `DashboardComponent`.
* Tie the *Dashboard* into the navigation structure.

{{< alert >}}
  *Routing* is another name for *navigation*. The router is the mechanism for navigating from view to view.
{{< /alert >}}

## Splitting the *AppComponent*

The current app loads `AppComponent` and immediately displays the list of heroes.
The revised app should present a shell with a choice of views (*Dashboard* and *Heroes*)
and then default to one of them.

The `AppComponent` should only handle navigation, so you'll
move the display of *Heroes* out of `AppComponent` and into its own `HeroListComponent`.

### *HeroListComponent*

`AppComponent` is already dedicated to *Heroes*.
Instead of moving the code out of `AppComponent`, rename it to `HeroListComponent`
and create a separate `AppComponent` shell.

Do the following:

* Rename and move the `app_component.*` files to `src/hero_list_component.*`.
* Drop the `src/` prefix from import paths.
* Rename the `AppComponent` class to `HeroListComponent` (rename locally, _only_ in this file).
* Rename the selector `my-app` to `my-heroes`.
* Change the template URL to `hero_list_component.html` and style file to `hero_list_component.css`.

{{< excerpt src="lib/src/hero_list_component.dart" section="renaming" >}}

### Create *AppComponent*

The new `AppComponent` is the app shell.
It will have some navigation links at the top and a display area below.

Perform these steps:

* Create the file `lib/app_component.dart`.
* Define an `AppComponent` class.
* Add an `@Component` annotation above the class with a `my-app` selector.
* Move the following from the hero list component to the app component:
  * The `title` class property.
  * The template `<h1>` element, which contains a binding to  `title`.
* Add a `<my-heroes>` element to the app template just below the heading so you still see the heroes.
* Add `HeroListComponent` to the `directives` list of `AppComponent` so Angular recognizes the `<my-heroes>` tags.
* Add `HeroService` to the  `providers` list of `AppComponent` because you'll need it in every other view.
* Remove `HeroService` from the `HeroListComponent` `providers` list since it was promoted.
* Add the supporting `import` statements for `AppComponent`.

The first draft looks like this:

{{< excerpt src="lib/app_component_1.dart" >}}

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser.** The app still runs and displays heroes. -->

## Add routing

Instead of displaying automatically, heroes should display after users click a button.
In other words, users should be able to navigate to the list of heroes.

### Update the pubspec

Use the Angular router ([ngrouter][]) to enable navigation. Since the
router is in its own package, first add the package to the app's pubspec:

{{< alert context="warning" >}}
Package versions may not be up-to-date. Prefer running `dart pub add ngrouter` to
automatically add the correct version.
{{< /alert >}}

<!-- <?code-excerpt "toh-4/pubspec.yaml" diff-with="toh-5/pubspec.yaml" to="ngrouter"?> -->
```diff
--- toh-4/pubspec.yaml
+++ toh-5/pubspec.yaml
@@ -8,3 +8,4 @@
 dependencies:
   ngdart: ^7.1.1
   ngforms: ^4.1.1
+  ngrouter: ^3.1.1
```

Not all apps need routing, which is why the Angular router is
in a separate, optional package.

### Import the library

The Angular router is a combination of multiple services
([routerProviders][]/[routerProvidersHash][]),
directives ([routerDirectives][]), and
configuration classes. You get them all by importing
the router library:

{{< excerpt src="lib/app_component.dart" section="angular_router" >}}

### Make the router available

To tell Angular that your app uses the router, pass as an argument to `runApp()`
an injector seeded with [routerProvidersHash][]:

{{< excerpt src="web/main.dart" >}}

<!-- {% include location-strategy-callout.md %} -->

### *\<base href>*

Open `index.html` and ensure there is a `<base href="...">` element
(or a script that dynamically sets this element)
at the top of the `<head>` section.

<!-- TODO: router/1 -->
As explained in the [Set the base href]({{< ref router >}}#base-href)
section of the [Routing and Navigation]({{< ref router >}}) page,
the example apps use the following script:

{{< excerpt src="web/index.html" section="base-href" >}}

### Configure routes

*Routes* tell the router which views to display when a user clicks a link or
pastes a URL into the browser address bar.

First create a file to hold route paths. Initialize it with this content:

{{< excerpt src="lib/src/route_paths.dart" section="v1" >}}

As a first route, define a route to the heroes component:

{{< excerpt src="lib/src/routes.dart" section="a-first-route" >}}

The `Routes.all` field is a list of *route definitions*.
It contains only one route, but you'll be adding more routes shortly.

The heroes [RouteDefinition][] has the following named arguments:

- `routePath`: The router matches this path against the URL in the browser
  address bar (`heroes`).
- `component`: The (factory of the) component that will be activated when this
  route is navigated to (`hero_list_template.HeroListComponentNgFactory`).

{{< alert >}}
Read more about defining routes in the [Routing & Navigation](/guide/router) page.
{{< /alert >}}

The Angular compiler generates **component factories** behind the scenes when
you build the app. To access the factory you need to import the generated
component template file:

{{< excerpt src="lib/src/routes.dart" section="hero_list_template" >}}

Until you've built the app, the generated files don't exist. The analyzer
normally reports a missing import as an error, but we've disabled this error
using the following configuration:

```yaml
analyzer:
  errors:
    uri_has_not_been_generated: ignore
```

By naming the import (`hero_list_template`) you can use the not-yet-generated
component factory without an error from the analyzer

### Router outlet

When you visit [localhost:8080/#/heroes](http://localhost:8080/#/heroes),
the router should match the URL to the heroes route and display a `HeroListComponent`.
However, you have to tell the router where to display the component.

To do this, open `app_component.dart` and make the following changes:

- Add [routerDirectives][] to the directives list. [RouterOutlet][] is one of
  the `routerDirectives`.
- Add a `<router-outlet>` element at the end of the template. The router
  displays each component immediately below the `<router-outlet>` as users
  navigate through the app.
- Remove `<my-heroes>` from the template because `AppComponent` won't directly
  display heroes, that's the router's job.
- Remove `HeroListComponent` from the directives list.

The `<router-outlet>` takes a list of routes as input, so make these changes:

- Import the app routes.
- Add an `exports` argument to the `@Component` annotation, and export
  `RoutePaths` and `Routes` (you'll be using `RoutePaths` shortly).
- In the template, bind the `routes` property of the `<router-outlet>` to
  `Routes.all`.

The app component code should look like this:

{{< excerpt src="lib/app_component.dart" section="routes-and-template" >}}

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser,** then visit
[localhost:8080/#/heroes](http://localhost:8080/#/heroes){:.no-automatic-external}.
You should see the heroes list. -->

### Router links

Users shouldn't have to paste a route path into the address bar.
Instead, add an anchor to the template that, when clicked,
triggers navigation to `HeroListComponent`.

The revised template looks like this:

<!-- TODO: maybe don't need to show the dashboard part? -->
{{< excerpt src="lib/app_component.dart" section="template" >}}

Note the `routerLink` [property binding][] in the anchor tag. The [RouterLink][] directive
is bound to an expression whose string value that tells the router where to navigate to when the user
clicks the link.

Looking back at the route definitions, you can confirm that
`'heroes'` is the path of the route to the `HeroListComponent`.

<!-- 
<div class="callout is-important" markdown="1">
  Notice that `routerLink` is bound to `/heroes` and not `/#/heroes`, even if
  your app uses the [HashLocationStrategy][] during development.  This uniform
  use of route paths makes it easy to switch to the [PathLocationStrategy][]
  when deploying in production.
</div>
-->

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser**. The browser displays the app title and heroes link,
but not the heroes list. Click the *Heroes* navigation link. The address bar
updates to `/#/heroes` (or the equivalent `/#heroes`),
and the list of heroes displays. -->

`AppComponent` now looks like this:

<!-- TODO: maybe don't need to show the dashboard part? -->
{{< excerpt src="lib/app_component.dart" >}}

The  *AppComponent* has a router and displays routed views.
For this reason, and to distinguish it from other kinds of components,
this component type is called a *router component*.

## Add a dashboard

Routing only makes sense when multiple views exist.
To add another view, create a placeholder `DashboardComponent`.

{{< excerpt src="lib/src/dashboard_component_1.dart" section="v1" >}}

You'll make this component more useful later.

### Configure the dashboard route

Add a dashboard route similar to the heroes route by adding a path
and then creating a route definition.

{{< excerpt src="lib/src/route_paths.dart" section="dashboard" >}}

{{< excerpt src="lib/src/routes.dart" section="dashboard" >}}

You'll also need to import the compiled dashboard template:

{{< excerpt src="lib/src/routes.dart" section="dashboard_template" >}}

### Add a redirect route

Currently, the browser launches with `/` in the address bar.
When the app starts, it should show the dashboard and
display the `/#/dashboard` path in the address bar.

To make this happen, add a redirect route:

{{< excerpt src="lib/src/routes.dart" section="redirect-route" >}}

<!-- TODO: ref to advanced/router !-->
{{< alert context="info" >}}
Alternatively, you could define `Dashboard` as a _default_ route.
Read more about
[default routes](/guide/router/2#default-route) and
[redirects](/guide/router/2#redirect-route) in the
[Routing & Navigation](/guide/router/2) page.
{{< /alert >}}

### Add navigation to the dashboard

Add a dashboard link to the app component template, just above the heroes link.

{{< excerpt src="lib/app_component.dart" section="template" >}}

{{< alert >}}
  The `<nav>` element and the `routerLinkActive` directives don't do anything yet,
  but they'll be useful later when you [style the links](#style-the-navigation-links).
{{< /alert >}}

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i> **Refresh the browser,** then
visit [localhost:8080/](http://localhost:8080/){:.no-automatic-external}. The
app displays the dashboard and you can navigate between the dashboard and the
heroes list. -->

## Add heroes to the dashboard

To make the dashboard more interesting, you'll display the top four heroes at a glance.

Replace the `template` metadata with a `templateUrl` property that points to a new
template file, and add the directives shown below (you'll add the necessary imports soon):

{{< excerpt src="lib/src/dashboard_component_2.dart" section="metadata-wo-styles" >}}

{{< alert >}}
  The value of `templateUrl` can be an asset in this package or another
  package. To refer to an asset from another package, use a full package reference,
  such as `'package:some_other_package/dashboard_component.html'`.
{{< /alert >}}

Create the template file with this content:

{{< excerpt src="lib/src/dashboard_component_1.html" >}}

`*ngFor` is used again to iterate over a list of heroes and display their names.
The extra `<div>` elements will help with styling later.

### Reusing the *HeroService*

To populate the component's `heroes` list, you can reuse the `HeroService`.

Earlier, you removed the `HeroService` from the `providers` list of `HeroListComponent`
and added it to the `providers` list of `AppComponent`.
That move created a singleton `HeroService` instance, available to all components of the app.
Angular injects `HeroService` and you can use it in the `DashboardComponent`.

### Get heroes

In `dashboard_component.dart`, add the following `import` statements.

{{< excerpt src="lib/src/dashboard_component_2.dart" section="imports" >}}

Now create the `DashboardComponent` class like this:

{{< excerpt src="lib/src/dashboard_component_2.dart" section="class" >}}

You're using the same kind of features for the dashboard as you did for the heroes component:

* Define a `heroes` list property.
* Inject a `HeroService` in the constructor, saving it to a private field.
* Call the service to get heroes inside the Angular `ngOnInit()` lifecycle hook.

In this dashboard you specify four heroes (2nd, 3rd, 4th, and 5th).

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser** to see four hero names in the new dashboard. -->

## Navigating to hero details

While the details of a selected hero display at the bottom of the `HeroListComponent`,
users should be able to navigate to a `HeroComponent` in the following additional ways:

* From the dashboard to a selected hero.
* From the heroes list to a selected hero.
* From a "deep link" URL pasted into the browser address bar.

### Routing to a hero detail

You can add a route to the `HeroComponent` in `AppComponent`, where the other routes are defined.

The new route is unusual in that you must tell the `HeroComponent` which hero to show.
You didn't have to tell the `HeroListComponent` or the `DashboardComponent` anything.

Currently, the parent `HeroListComponent` sets the component's `hero` property to a
hero object with a binding like this:

{{< excerpt base="toh-3" src="lib/app_component.html" section="my-hero" >}}

But this binding won't work in any of the routing scenarios.

### Parameterized route

You can add the hero's ID to the route path. When routing to the hero whose ID is 11,
you could expect to see a path such as this:

```nocode
/heroes/11
```

The `/heroes/` part is constant. The trailing numeric ID changes from hero to hero.
You need to represent the variable part of the route with a *parameter* that stands for the hero's ID.

### Add a route with a parameter

First, define the route path:

{{< excerpt src="lib/src/route_paths.dart" section="hero" >}}

The colon (:) in the path indicates that `:$idParam` (`:id`) is a placeholder
for a specific hero ID when navigating to hero view.

In the routes file, import the hero detail component template:

{{< excerpt src="lib/src/routes.dart" section="hero_template" >}}

Next, add the following route:

{{< excerpt src="lib/src/routes.dart" section="hero" >}}

You're finished with the app routes.

You didn't add a hero detail link to the template because users
don't click a navigation *link* to view a particular hero;
they click a *hero name*, whether the name is displayed on the dashboard or in the heroes list.
But this won't work until the `HeroComponent`
is revised and ready to be navigated to.

## Revise *HeroComponent*

Here's what the `HeroComponent` looks like now:

{{< excerpt base="toh-4" src="lib/src/hero_component.dart" section="current" >}}

The template won't change. Hero names will display the same way.
The major changes are driven by how you get hero names.

### Drop *@Input()*

You will no longer receive the hero in a parent component property binding, so
you can **remove the `@Input()` annotation** from the `hero` field:

{{< excerpt src="lib/src/hero_component.dart" section="hero" pattern="implements \w+ " replace="" >}}

### Add *onActivate()* life-cycle hook

The new `HeroComponent` will take the `id` parameter from the router's
state and use the `HeroService` to fetch the hero with that `id`.

Add the following imports:

{{< excerpt src="lib/src/hero_component.dart" section="added-imports" >}}

Inject the `HeroService` and [Location][] service
into the constructor, saving their values in private fields:

{{< excerpt src="lib/src/hero_component.dart" section="ctor" >}}

To get notified when a hero route is navigated to, make `HeroComponent`
implement the [OnActivate][] interface, and update `hero` from
the [onActivate()][] [router lifecycle hook][]:

{{< excerpt src="lib/src/hero_component.dart" section="OnActivate" >}}

The hook implementation makes use of the `getId()` helper function that
extracts the `id` from the [RouterState.parameters][] map.

{{< excerpt src="lib/src/route_paths.dart" section="getId" >}}

The hero ID is a number. Route parameters are always strings.
So the route parameter value is converted to a number.

### Add *HeroService.get()*

In `onActivate()`, you used the `get()` method, which `HeroService` doesn't
have yet. To fix this issue, open `HeroService` and add a `get()` method
that filters the heroes list from `getAll()` by `id`.

{{< excerpt src="lib/src/hero_service.dart" section="get" >}}

### Find the way back

Users have several ways to navigate *to* the `HeroComponent`.

To navigate somewhere else, users can click one of the two links in the `AppComponent` or click the browser's back button.
Now add a third option, a `goBack()` method that navigates backward one step in the browser's history stack
using the `Location` service you injected previously.

{{< excerpt src="lib/src/hero_component.dart" section="goBack" >}}

{{< alert >}}
  Going back too far could take users out of the app.
  In a real app, you can prevent this issue with the _canDeactivate()_ hook.
  Read more on the [CanDeactivate]({{< param pubApi >}}/ngrouter/latest/angular_router/CanDeactivate-class.html) page.
{{< /alert >}}

You'll wire this method with an event binding to a *Back* button that you'll add to the component template.

{{< excerpt src="lib/src/hero_component.html" section="back-button" >}}

Migrate the template to its own file called `hero_component.html`:

{{< excerpt src="lib/src/hero_component.html" >}}

Update the component metadata with a `templateUrl` pointing to the template file that you just created.

{{< excerpt src="lib/src/hero_component.dart" section="metadata-wo-style" >}}

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser** and visit
[localhost:8080/#heroes/11](http://localhost:8080/#heroes/11){:.no-automatic-external}.
Details for hero 11 should be displayed. Selecting a hero
in either the dashboard or the heroes list doesn't work yet.
You'll deal with that next. -->

## Select a dashboard hero

When a user selects a hero in the dashboard, the app should navigate to a
`HeroComponent` to allow the user to view and edit the selected hero.

The dashboard heroes should behave like anchor tags:
when hovering over a hero name, the target URL should display in the browser status bar
and the user should be able to copy the link or open the hero detail view in a new tab.

To achieve this, you'll need to make changes to the dashboard component and its
template.

Update the dashboard component:

- Import `route_paths.dart`
- Add `routerDirectives` to the `directives` list
- Add the following method:

{{< excerpt src="lib/src/dashboard_component.dart" section="heroUrl" >}}

Edit the dashboard template:

- Replace the `div` opening and closing tags in the `<div *ngFor...>` element
  with anchor tags.
- Add a router link property binding, as shown.

{{< excerpt src="lib/src/dashboard_component.html" section="click" >}}

As described in the [Router links](#router-links) section of this page,
top-level navigation in the `AppComponent` template has router links set to
paths like, `/dashboard` and `/heroes`. This time, you're binding to the
parameterized `hero` path you defined earlier:

{{< excerpt src="lib/src/route_paths.dart" section="hero" >}}

The `heroUrl()` method generates the string representation of the path using the
`toUrl()` method, passing route parameter values using a map literal. For
example, it returns [/heroes/15](localhost:8080/#/heroes/15) when `id` is 15.

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser** and select a hero from the dashboard; the app navigates to that hero’s details. -->

## Select a hero in the *HeroListComponent*

In the `HeroListComponent`,
the current template exhibits a "master/detail" style with the list of heroes
at the top and details of the selected hero below.

{{< excerpt src="lib/src/hero_list_component_1.html" >}}

You'll no longer show the full `HeroComponent` here.
Instead, you'll display the hero detail on its own page and route to it as you did in the dashboard.
Make these changes:

- Remove the `<my-hero>` element from the last line of the template.
- Remove `HeroComponent` from list of `directives`.
- Remove the hero detail import.

When users select a hero from the list, they won't go to the detail page.
Instead, they'll see a mini detail on *this* page and have to click a button to navigate to the *full detail* page.

### Add the *mini detail*

Add the following HTML fragment at the bottom of the template where the `<my-hero>` used to be:

{{< excerpt src="lib/src/hero_list_component.html" section="mini-detail" >}}

Add the following import and method stub to `HeroListComponent`:

{{< excerpt src="lib/src/hero_list_component.dart" section="gotoDetail-stub" >}}

After clicking a hero (but don't try now since it won't work yet), users should see something like this below the hero list:

{{< figure src="mini-hero-detail.png" width="250" alt="Mini Hero Detail" >}}

The hero's name is displayed in capital letters because of the `uppercase` pipe
that's included in the interpolation binding, right after the pipe operator ( | ).

{{< excerpt src="lib/src/hero_list_component.html" section="pipe" >}}

Pipes are a good way to format strings, currency amounts, dates and other display data.
Angular ships with several pipes and you can write your own.

<i class="material-icons">warning</i> Before you can use an Angular pipe in a
template, you need to list it in the `pipes` argument of your component's
`@Component` annotation. You can add pipes
individually, or for convenience you can use groups like [commonPipes][].

{{< excerpt src="lib/src/hero_list_component.dart" section="pipes" >}}

{{< alert context="info" >}}
  Read more about pipes on the [Pipes]({{< ref pipes >}}) page.
{{< /alert >}}

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser.** Selecting a hero from the heroes list will activate the mini
detail view. The view details button doesn't work yet. -->

### Update the _HeroListComponent_ class

The `HeroListComponent` navigates to the `HeroesDetailComponent` in response to a button click.
The button's click event is bound to a `gotoDetail()` method that should navigate _imperatively_
by telling the router where to go.

This approach requires the following changes to the component class:

- Import `route_paths.dart`.
- Inject the `Router` in the constructor, along with the `HeroService`.
- Implement `gotoDetail()` by calling the router `navigate()` method.

Here's the revised `HeroListComponent` class:

{{< excerpt src="lib/src/hero_list_component.dart" section="class" >}}

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser** and start clicking.
Users can navigate around the app, from the dashboard to hero details and back,
from heroes list to the mini detail to the hero details and back to the heroes again. -->

You've met all of the navigational requirements that propelled this page.

## Style the app

The app is functional but it needs styling.
The dashboard heroes should display in a row of rectangles.
You've received around 60 lines of CSS for this purpose, including some simple media queries for responsive design.

As you now know, adding the CSS to the component `styles` metadata
would obscure the component logic.
Instead, you'll add the CSS to separate `.css` files.

### Dashboard styles

Create a `dashboard_component.css` file in the `lib/src` folder and reference
that file in the component metadata's `styleUrls` list property like this:

{{< codetabs
    "lib/src/dashboard_component.dart"
    "lib/src/dashboard_component.css"
>}}
<!-- 
<code-tabs>
  <?code-pane "lib/src/dashboard_component.dart (styleUrls)" region="metadata" linenums?>
  <?code-pane "lib/src/dashboard_component.css" linenums?>
</code-tabs>
-->


### Hero detail styles

Create a `hero_component.css` file in the `lib/src`
folder and reference that file in the component metadata’s `styleUrls` list:

{{< codetabs
    "lib/src/hero_component.dart"
    "lib/src/hero_component.css"
>}}
<!--
<code-tabs>
</code-tabs>
-->

### Style the navigation links

Create an `app_component.css` file in the `lib` folder
and reference that file in the component metadata’s `styleUrls` list:

{{< codetabs
    "lib/app_component.dart"
    "lib/app_component.css"
>}}
<!--
<code-tabs>
  <?code-pane "lib/app_component.dart (styleUrls)" linenums?>
  <?code-pane "lib/app_component.css" linenums?>
</code-tabs>
!-->

The provided CSS makes the navigation links in the `AppComponent` look more like selectable buttons.
Earlier, you surrounded those links with a `<nav>` element,
and added a `routerLinkActive` directive to each anchor:

{{< excerpt src="lib/app_component.dart" section="template" >}}

The router adds the class named by the [RouterLinkActive][] directive to
the HTML navigation element whose route matches the active route.

### Global app styles

When you add styles to a component, you keep everything a component needs&mdash;HTML,
the CSS, the code&mdash;together in one convenient place.
It's easy to package it all up and reuse the component somewhere else.

You can also create styles at the *app level* outside of any component.

The designers provided some basic styles to apply to elements across the entire app.
These correspond to the full set of master styles that you installed earlier during [setup](/guide/setup).
Here's an excerpt:

<!-- <?code-excerpt path-base="examples/ng/doc/_boilerplate"?> -->

<!-- TODO: no highlighting for CSS? -->
{{< excerpt src="web/styles.css" section="toh" >}}

Create the file `web/styles.css`, if necessary.
Ensure that the file contains the [master styles provided here][master styles].
Also edit `web/index.html` to refer to this stylesheet.

{{< excerpt src="web/index.html" section="css" >}}

Look at the app now. The dashboard, heroes, and navigation links are styled.

<img class="image-display" src="{% asset ng/devguide/toh/dashboard-top-heroes.png @path %}" alt="View navigations">

## App structure and code

Review the sample source code in the {% example_ref %} for this page.
Verify that you have the following structure:

<div class="ul-filetree">
{{< markdownify >}}
- angular_tour_of_heroes
  - lib
    - app_component.{css,dart}
    - src
      - dashboard_component.{css,dart,html}
      - hero.dart
      - hero_component.{css,dart,html}
      - hero_list_component.{css,dart,html}
      - hero_service.dart
      - mock_heroes.dart
      - route_paths.dart
      - routes.dart
  - test
    - ...
  - web
    - index.html
    - main.dart
    - styles.css
  - analysis_options.yaml
  - pubspec.yaml
{{< /markdownify >}}
</div>

## The road you’ve travelled

Here's what you achieved in this page:

- You added the Angular router to navigate among different components.
- You learned how to create router links to represent navigation menu items.
- You used router link parameters to navigate to the details of the user-selected hero.
- You shared the `HeroService` among multiple components.
- You added the `uppercase` pipe to format data.

Your app should look like this {{< exref toh-5 >}}.

### The road ahead

You have much of the foundation you need to build an app.
You're still missing a key piece: remote data access.

In the next page,
you’ll replace the mock data with data retrieved from a server using http.

<!-- TODO: Add Recap and What's next sections -->

[ngrouter]: {{< param pubPkg >}}/ngrouter
[commonPipes]: {{< param pubApi >}}/ngdart/latest/angular/commonPipes-constant.html
[deep linking]: https://en.wikipedia.org/wiki/Deep_linking
[master styles]: https://raw.githubusercontent.com/ngdart/angular.io/master/public/docs/_examples/_boilerplate/src/styles.css
[HashLocationStrategy]: {{< param pubApi >}}/ngrouter/latest/angular_router/HashLocationStrategy-class.html
[Location]: {{< param pubApi >}}/ngrouter/latest/angular_router/Location-class.html
[OnActivate]: {{< param pubApi >}}/ngrouter/latest/angular_router/OnActivate-class.html
[onActivate()]: /guide/router/5#on-activate
[property binding]: {{< ref template-syntax >}}#property-binding
[PathLocationStrategy]: {{< param pubApi >}}/ngrouter/latest/angular_router/PathLocationStrategy-class.html
[router lifecycle hook]: /guide/router/5
[RouteDefinition]: {{< param pubApi >}}/ngrouter/latest/angular_router/RouteDefinition-class.html
[routerDirectives]: {{< param pubApi >}}/ngrouter/latest/angular_router/routerDirectives-constant.html
[RouterLink]: {{< param pubApi >}}/ngrouter/latest/angular_router/RouterLink-class.html
[RouterLinkActive]: {{< param pubApi >}}/ngrouter/latest/angular_router/RouterLinkActive-class.html
[RouterOutlet]: {{< param pubApi >}}/ngrouter/latest/angular_router/RouterOutlet-class.html
[routerProviders]: {{< param pubApi >}}/ngrouter/latest/angular_router/routerProviders-constant.html
[routerProvidersHash]: {{< param pubApi >}}/ngrouter/latest/angular_router/routerProvidersHash-constant.html
[RouterState]: {{< param pubApi >}}/ngrouter/latest/angular_router/RouterState-class.html
[RouterState.parameters]: {{< param pubApi >}}/ngrouter/latest/angular_router/RouterState/parameters.html
