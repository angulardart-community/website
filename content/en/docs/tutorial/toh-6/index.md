---
title: "6. HTTP"
description: "Convert the service and components to use Angular's HTTP service."
lead: ""
date: 2023-03-09T22:19:06-05:00
lastmod: 2023-03-09T22:19:06-05:00
draft: false
images: []
menu:
  docs:
    parent: "tutorial"
    identifier: "toh-6"
weight: 270
toc: true
excerptbase: "toh-6"
---

In this page, you'll make the following improvements.

  - Get the hero data from a server.
  - Let users add, edit, and delete hero names.
  - Save the changes to the server.

You'll teach the app to make corresponding HTTP calls to a remote server's web API.

When you're done with this page, the app should look like this {{< exref toh-6 >}}.

## Where you left off

In the [previous page]({{< ref toh-5 >}}), you learned to navigate between the dashboard and the fixed heroes list, editing a selected hero along the way. That's the starting point for this page.

Before continuing with the Tour of Heroes, verify that you have the following structure.

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

<a id="http-providers"></a>

## Providing HTTP services

You'll be using the Dart [http][] package's client classes to communicate with a server.

### Pubspec updates

Update package dependencies by adding the Dart [http][] and
[stream_transform][] packages:

{{< alert context="warning" >}}
Package versions may not be up-to-date. Consider adding the dependencies using `dart
pub add` instead to automatically resolve to the latest compatible version.
{{< /alert >}}
```diff
--- toh-5/pubspec.yaml
+++ toh-6/pubspec.yaml
@@ -9,6 +9,8 @@
   ngdart: ^7.1.1
   ngforms: ^4.1.1
   ngrouter: ^3.1.1
+  http: ^0.13.4
+  stream_transform: ^2.0.0

 dev_dependencies:
   ngtest: ^4.1.1
```

## Register for HTTP services

Before the app can use `BrowserClient`, you have to register it as a service provider.

You should be able to access `BrowserClient` services from anywhere in the app,
so provide it through the app's root injector:

{{< excerpt src="web/main_1.dart" >}}

Notice that you supply `BrowserClient` as a class provider in list argument of
the generated injector. This has the same effect as the `providers` list in
`@Component` annotation.

{{< alert context="warning" >}}
**Note:** Unless you have an appropriately configured backend server (or a mock server),
this app doesn't work. The next section shows how to mock interaction with a backend server.
{{< /alert >}}

## Simulate the web API

Until you have a web server that can handle requests for hero data,
the HTTP client will fetch and save data from
a mock service, the *in-memory web API*.

Update `web/main.dart` with this version, which uses the mock service:

{{< excerpt src="web/main.dart" >}}

Replace `BrowserClient`, the service that talks to the remote server,
with the in-memory web API service.
The in-memory web API service, shown below, is implemented using the
`http` library `MockClient` class.
All `http` client implementations share a common `Client` interface, so
you'll have the app use the `Client` type so that you can freely switch between
implementations.

{{< excerpt src="lib/in_memory_data_service.dart" section="init" >}}

This file replaces `mock_heroes.dart`, which is now safe to delete.

As is common for web API services, the mock in-memory service will be
encoding and decoding heroes in JSON format, so enhance the `Hero`
class with these capabilities:

{{< excerpt src="lib/src/hero.dart" >}}

## Heroes and HTTP

In the current `HeroService` implementation, a Future resolved with mock heroes is returned.

{{< excerpt base="toh-4" src="lib/src/hero_service.dart" section="getAll" >}}

This was implemented in anticipation of ultimately
fetching heroes with an HTTP client, which must be an asynchronous operation.

Now convert `getAll()` to use HTTP.

{{< excerpt src="lib/src/hero_service.dart" section="getAll" >}}

Update the import statements as follows:

{{< excerpt src="lib/src/hero_service.dart" section="imports" >}}

Refresh the browser. The hero data should successfully load from the mock server.

### HTTP Future

To get the list of heroes, you first make an asynchronous call to
`http.get()`. Then you use the `_extractData` helper method to decode the
response body.

The response JSON has a single `data` property, which
holds the list of heroes that the caller wants.
So you grab that list and return it as the resolved Future value.

{{< alert context="info" >}}
Note the shape of the data that the server returns.
This particular in-memory web API example returns an object with a `data` property.
Your API might return something else. Adjust the code to match your web API.
{{< /alert >}}

The caller is unaware that you fetched the heroes from the (mock) server.
It receives a Future of *heroes* just as it did before.

### Error Handling

At the end of `getAll()`, you `catch` server failures and pass them to an error handler.

{{< excerpt src="lib/src/hero_service.dart" section="catch" >}}

This is a critical step. You must anticipate HTTP failures, as they happen frequently for reasons beyond your control.

{{< excerpt src="lib/src/hero_service.dart" section="handleError" >}}

This demo service logs the error to the console; in real life,
you would handle the error in code. For a demo, this works.

The code also includes an error to the caller in a propagated exception, so that the caller can display a proper error message to the user.


### Get hero by id

When the `HeroComponent` asks the `HeroService` to fetch a hero,
the `HeroService` currently fetches all heroes and
filters for the one with the matching `id`.
That's fine for a simulation, but it's wasteful to ask a real server for all heroes when you only want one.
Most web APIs support a _get-by-id_ request in the form `api/hero/:id` (such as `api/hero/11`).

Update the `HeroService.get()` method to make a _get-by-id_ request:

{{< excerpt src="lib/src/hero_service.dart" section="get" >}}

This request is almost the same as `getAll()`.
The hero id in the URL identifies which hero the server should update.

Also, the `data` in the response is a single hero object rather than a list.

### Unchanged _getAll_ API

Although you made significant internal changes to `getAll()` and `get()`,
the public signatures didn't change.
You still return a Future from both methods.
You won't have to update any of the components that call them.

Now it's time to add the ability to create and delete heroes.

## Updating hero details

Try editing a hero's name in the hero detail view.
As you type, the hero name is updated in the view heading.
But if you click the Back button, the changes are lost.

Updates weren't lost before. What changed?
When the app used a list of mock heroes, updates were applied directly to the
hero objects within the single, app-wide, shared list. Now that you're fetching data
from a server, if you want changes to persist, you must write them back to
the server.

### Add the ability to save hero details

At the end of the hero detail template, add a save button with a `click` event
binding that invokes a new component method named `save()`.

{{< excerpt src="lib/src/hero_component.html" section="save" >}}

Add the following `save()` method, which persists hero name changes using the hero service
`update()` method and then navigates back to the previous view.

{{< excerpt src="lib/src/hero_component.dart" section="save" >}}

### Add a hero service _update()_ method

The overall structure of the `update()` method is similar to that of
`getAll()`, but it uses an HTTP `put()` to persist server-side changes.

{{< excerpt src="lib/src/hero_service.dart" section="update" >}}

To identify which hero the server should update, the hero `id` is encoded in
the URL. The `put()` body is the JSON string encoding of the hero, obtained by
calling `JSON.encode`. The body content type
(`application/json`) is identified in the request header.

Refresh the browser, change a hero name, save your change,
and click the browser Back button. Changes should now persist.

## Add the ability to add heroes

To add a hero, the app needs the hero's name. You can use an `input`
element paired with an add button.

Insert the following into the heroes component HTML, just after
the heading:

{{< excerpt src="lib/src/hero_list_component.html" section="add" >}}

In response to a click event, call the component's click handler and then
clear the input field so that it's ready for another name.

{{< excerpt src="lib/src/hero_list_component.dart" section="add" >}}

When the given name is non-blank, the handler delegates creation of the
named hero to the hero service, and then adds the new hero to the list.

Implement the `create()` method in the `HeroService` class.

{{< excerpt src="lib/src/hero_service.dart" section="create" >}}

Refresh the browser and create some heroes.

## Add the ability to delete a hero

Each hero in the heroes view should have a delete button.

Add the following button element to the heroes component HTML, after the hero
name in the repeated `<li>` element.

{{< excerpt src="lib/src/hero_list_component.html" section="delete" >}}

The `<li>` element should now look like this:

{{< excerpt src="lib/src/hero_list_component.html" section="li-element" >}}

In addition to calling the component's `delete()` method, the delete button's
click handler code stops the propagation of the click event&mdash;you
don't want the `<li>` click handler to be triggered because doing so would
select the hero that the user will delete.

The logic of the `delete()` handler is a bit trickier:

{{< excerpt src="lib/src/hero_list_component.dart" section="delete" >}}

Of course you delegate hero deletion to the hero service, but the component
is still responsible for updating the display: it removes the deleted hero
from the list and resets the selected hero, if necessary.

To place the delete button at the far right of the hero entry,
add this CSS:

{{< excerpt src="lib/src/hero_list_component.css" section="additions" >}}

### Hero service _delete()_ method

Add the hero service's `delete()` method, which uses the `delete()` HTTP method to remove the hero from the server:

{{< excerpt src="lib/src/hero_service.dart" section="delete" >}}

Refresh the browser and try the new delete functionality.

## Streams

Recall that `HeroService.getAll()` awaits for an `http.get()`
response and yields a _Future_ `List<Hero>`, which is fine when you are only
interested in a single result.

But requests aren't always done only once.
You may start one request,
cancel it, and make a different request before the server has responded to the first request.
A *request-cancel-new-request* sequence is difficult to implement with *Futures*, but
easy with *Streams*.

### Add the ability to search by name

You're going to add a *hero search* feature to the Tour of Heroes.
As the user types a name into a search box, you'll make repeated HTTP requests for heroes filtered by that name.

Start by creating `HeroSearchService` that sends search queries to the server's web API.

{{< excerpt src="lib/src/hero_search_service.dart" >}}

The `_http.get()` call in `HeroSearchService` is similar to the one
in the `HeroService`, although the URL now has a query string.

### HeroSearchComponent

Create a `HeroSearchComponent` that calls the new `HeroSearchService`.

The component template is simple&mdash;just a text box and a list of matching search results.

{{< excerpt src="lib/src/hero_search_component.html" >}}

Also, add styles for the new component.

{{< excerpt src="lib/src/hero_search_component.css" >}}

As the user types in the search box, a *keyup* event binding calls the component's `search()`
method with the new search box value. If the user pastes text with mouse actions,
the *change* event binding is triggered.

As expected, the `*ngFor` repeats hero objects from the component's `heroes` property.

But as you'll soon see, the `heroes` property is now a *Stream* of hero lists, rather than just a hero list.
The `*ngFor` can't do anything with a `Stream` until you route it through the `async` pipe (`AsyncPipe`).
The `async` pipe subscribes to the `Stream` and produces the list of heroes to `*ngFor`.

Create the `HeroSearchComponent` class and metadata.

{{< excerpt src="lib/src/hero_search_component.dart" >}}

#### Search terms

Focus on `_searchTerms`:

{{< excerpt src="lib/src/hero_search_component.dart" section="searchTerms" >}}

A [StreamController][], as its name implies, is a controller for a [Stream][] that allows you to
manipulate the underlying stream by adding data to it, for example.

In the sample, the underlying stream of strings (`_searchTerms.stream`) represents the hero
name search patterns entered by the user. Each call to `search()` puts a new string into
the stream by calling `add()` over the controller.

#### Initialize the *heroes* property (*ngOnInit*)  {#ngoninit}

You can turn the stream of search terms into a stream of `Hero` lists and assign the result to the `heroes` property.

{{< excerpt src="lib/src/hero_search_component.dart" section="search" >}}

Passing every user keystroke directly to the `HeroSearchService` would create an excessive amount of HTTP requests,
taxing server resources and burning through the cellular network data plan.

Instead, you can chain `Stream` operators that reduce the request flow to the string `Stream`.
You'll make fewer calls to the `HeroSearchService` and still get timely results. Here's how:

* `transform(debounce(... 300)))` waits until the flow of search terms pauses for 300
  milliseconds before passing along the latest string.
  You'll never make requests more frequently than 300ms.
* `distinct()` ensures that a request is sent only if the filter text changed.
* `transform(switchMap(...))` calls the search service for each
  search term that makes it through `debounce()` and `distinct()`.
  It cancels and discards previous searches, returning only the
  latest search service stream element.
* `handleError()` handles errors. The simple example prints the error
  to the console; a real life app should do better.

### Add the search component to the dashboard

Add the hero search HTML element to the bottom of the `DashboardComponent` template.

{{< excerpt src="lib/src/dashboard_component.html" >}}

Finally, import `HeroSearchComponent` from `hero_search_component.dart` and add it to the `directives` list.

{{< excerpt src="lib/src/dashboard_component.dart" section="search" >}}

Run the app again. In the Dashboard, enter some text in the search box.
If you enter characters that match any existing hero names, you'll see something like this.

{{< figure src="toh-hero-search.png" alt="Hero Search Component" >}}

## App structure and code

Review the sample source code in the {{< exref toh-6 >}} for this page.
Verify that you have the following structure:

<div class="ul-filetree">
{{< markdownify >}}
- angular_tour_of_heroes
  - lib
    - app_component.{css,dart}
    - in_memory_data_service.dart (new)
    - src
      - dashboard_component.{css,dart,html}
      - hero.dart
      - hero_component.{css,dart,html}
      - hero_list_component.{css,dart,html}
      - hero_search_component.{css,dart,html} (new)
      - hero_search_service.dart (new)
      - hero_service.dart
      - route_paths.dart
      - routes.dart
  - test
    - ...
  - web
    - main.dart
    - index.html
    - styles.css
  - analysis_options.yaml
  - pubspec.yaml
{{< /markdownify >}}
</div>

## Home stretch

You're at the end of your journey, and you've accomplished a lot.

- You added the necessary dependencies to use HTTP in the app.
- You refactored `HeroService` to load heroes from a web API.
- You extended `HeroService` to support `post()`, `put()`, and `delete()` methods.
- You updated the components to allow adding, editing, and deleting of heroes.
- You configured an in-memory web API.
- You learned how to use Streams.

Here are the files you added or changed in this page.

{{< codetabs
    "lib/src/dashboard_component.dart"
    "lib/src/dashboard_component.html"
    "lib/src/hero.dart"
    "lib/src/hero_component.dart"
    "lib/src/hero_component.html"
    "lib/src/hero_service.dart"
    "lib/src/hero_list_component.css"
    "lib/src/hero_list_component.dart"
    "lib/in_memory_data_service.dart"
>}}

{{< codetabs
    "lib/src/hero_search_component.css"
    "lib/src/hero_search_component.dart"
    "lib/src/hero_search_component.html"
    "lib/src/hero_search_service.dart"
>}}

{{< codetabs
    "pubspec.yaml"
    "web/main.dart"
>}}

## Next step

Return to the [learning path]({{< ref learning-angular >}}), where
you can read more about the concepts and practices found in this tutorial.

[http]: https://pub.dev/packages/http
[stream_transform]: https://pub.dev/packages/stream_transform
[Stream]: {{< param dartApi >}}/stable/dart-async/Stream-class.html
[StreamController]: {{< param dartApi >}}/stable/dart-async/StreamController-class.html
