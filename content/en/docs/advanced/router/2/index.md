---
title: "Routes Basics"
description: "Default, Redirect and Wildcard Routes"
date: 2023-07-04T14:12:45-04:00
draft: false
images: []
menu:
  docs:
    parent: "router"
    identifier: "router-2"
weight: 372
toc: true
excerptbase: "router"
---

<!-- {% include_relative _milestone-nav.md selectedOption="2" %} !-->

## Default route

The initial URL in the browser bar after the app launches is something like [localhost:8080](localhost:8080).

That doesn't match any of the configured routes, which means that the app won't
display any component when it's launched.
The user must click one of the links to trigger a navigation and component display.

It would be nicer if the app had a **_default_ route**
that displayed the list of heroes immediately.
One way to achieve this is to add `useAsDefault: true` as an argument
to the `Heroes` route definition:

{{< excerpt src="lib/src/routes_2.dart" section="useAsDefault" >}}

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser** and try it. Notice that the heroes list is displayed
when the app launches, but that the URL path is `/`. !-->

## Redirect route

As an alternative solution, **remove** the `useAsDefault` argument that you just added,
and instead add a _redirect_ route that will translate an initial relative path (`'/'`)
to the desired default path (`/#/heroes`).

{{< excerpt src="lib/src/routes_2.dart" section="redirect" >}}

<!-- TODO: open in browser
<i class="material-icons">open_in_browser</i>
**Refresh the browser** and try it. Now the browser address bar path is `/#/heroes`
as if you'd navigated there directly. !-->

## Wildcard route

While you've created routes to `/#/crises` and `/#/heroes`,
what if the router is given another path?
Add a **wildcard** route so that all other paths are handled
by a "Not Found" (404) component:

{{< excerpt src="lib/src/routes_2.dart" section="wildcard" >}}

The path regular expression `'.+'` matches every non-empty path.
(Exclude the empty path so that it triggers the `useAsDefault` route you defined earlier.)
The router will select the wildcard route if it can't match a route earlier in the routes list.

## App code {#wrap-up}

In this short iteration you've tried default, redirect and wildcard routes.
Here are the files that were added or edited:

{{< codetabs
    "lib/src/routes_2.dart"
    "lib/src/not_found_component.dart"
>}}
<!-- <code-tabs>
  <?code-pane "lib/src/routes_2.dart" replace="/_\d((\.template)?\.dart)/$1/g" linenums?>
  <?code-pane "lib/src/not_found_component.dart" linenums?>
</code-tabs> !-->

<!--
{% comment %}
  <div class="ul-filetree" markdown="1">
  - router_example
    - lib
      - app_component.dart
      - src
        - crisis_list_component.dart
        - hero_list_component.dart
        - not_found_component.dart
        - route_paths.dart
        - routes.dart
    - web
      - index.html
      - main.dart
      - styles.css
  </div>

  //- makeTabs(
  `router/dart/lib/app_component_2.dart,
  router/dart/lib/crisis_list_component_1.dart,
  router/dart/lib/hero_list_component_1.dart,
  router/dart/lib/not_found_component.dart,
  router/dart/web/index.html,
  router/dart/web/main.dart`,
  '',
  `lib/app_component.dart,
  lib/crisis_list_component.dart,
  lib/hero_list_component.dart,
  lib/not_found_component.dart
  web/index.html,
  web/main.dart`)
{% endcomment %}
!-->
