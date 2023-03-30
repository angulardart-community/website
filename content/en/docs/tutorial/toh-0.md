---
title: "0. The Starter App"
description: ""
draft: false
images: []
menu:
  docs:
    parent: "tutorial"
    identifier: "toh-0"
weight: 210
toc: true
excerptbase: toh-0
---

This tutorial starts with a bare-bones Angular app.
Run the {{< exref toh-0 >}} to see the app.

## Create the app

Let's get started.
Create a project named `angular_tour_of_heroes`,
using WebStorm or the command line
and the [angular-examples/quickstart]({{< param angularOrg >}}/quickstart/)
GitHub project.
For detailed instructions, see
[Create a starter project]({{< ref setup >}}#create-a-starter-project)
from the [Setup for Development]({{< ref setup >}}) page.

## Run the app, and keep it running

Run the app from your IDE or the command line,
as explained in the
[Run the app]({{< ref setup >}}#run-the-app) section of the
[Setup for Development]({{< ref setup >}}) page.

You'll be making changes to the app throughout this tutorial.
When you are ready to view your changes, reload the browser window.
This will [reload the app]({{< ref setup >}}#reload-the-app).
As you save updates to the code, the `pub` tool detects changes and
serves the new app.

## Angular app basics

Angular apps are made up of _components_.
A _component_ is the combination of an HTML template and a component class that controls a portion of the screen. The starter app has a component that displays a simple string:

{{< excerpt src="lib/app_component.dart" >}}

Every component begins with an `@Component` [annotation]({{< ref glossary >}}#annotation '"annotation" explained')
that describes how the HTML template and component class work together.

The `selector` property tells Angular to display the component inside a custom `<my-app>` tag in the `index.html`.

{{< excerpt src="web/index.html" section="my-app" >}}

The `template` property defines a message inside an `<h1>` header.
The message starts with "Hello" and ends with `{!{name}!}`,
which is an Angular [interpolation binding](../guide/displaying-data) expression.
At runtime, Angular replaces `{!{name}!}` with
the value of the component's `name` property.
Interpolation binding is one of many Angular features you'll discover in this documentation.

<a id="seed"></a>

## The starter app's code

The app contains the following core files:

{{< codetabs
    "lib/app_component.dart"
    "test/app_test.dart"
    "web/main.dart"
    "web/index.html"
    "web/styles.css"
    "pubspec.yaml"
>}}

These files are organized as follows:

<div class="ul-filetree" markdown="1">
{{< markdownify >}}
- angular_tour_of_heroes
  - lib
    - app_component.dart
  - test
    - app_test.dart
  - web
    - index.html
    - main.dart
    - styles.css
  - analysis_options.yaml
  - pubspec.yaml
{{< /markdownify >}}
</div>

All the examples in this documentation have _at least these core files_.
Each file has a distinct purpose and evolves independently as the app grows.

<style>td, th {vertical-align: top}</style>
<table width="100%"><col width="20%"><col width="80%">
<tr><th>File</th> <th>Purpose</th></tr>
<tr>
  <td><code>lib/app_component.dart</code></td>
  <td markdown="1"> 
  {{< markdownify >}}
  Defines `<my-app>`, the **root** component of what will become a tree of nested components as the app evolves.
  {{< /markdownify >}}
  </td>
</tr><tr>
  <td><code>test/app_test.dart</code></td>
  <td markdown="1"> 
  {{< markdownify >}}
  Defines `AppComponent` tests. While testing isn't covered in this tutorial, you can learn how to test the Tour of Heroes app from the [Testing](../guide/testing) page.
  {{< /markdownify >}}
  </td>
</tr><tr>
  <td><code>web/main.dart</code></td>
  <td markdown="1"> 
  {{< markdownify >}}
  Launches the app in the browser.
  {{< /markdownify >}}
  </td>
</tr><tr>
  <td><code>web/index.html</code></td>
  <td markdown="1"> 
  {{< markdownify >}}
  Contains the `<my-app>` tag in its `<body>`. This is where the app lives!
  {{< /markdownify >}}
  </td>
</tr><tr>
  <td><code>web/styles.css</code></td>
  <td markdown="1"> 
  {{< markdownify >}}
  A set of styles used throughout the app.
  {{< /markdownify >}}
  </td>
</tr><tr>
  <td><code>analysis_options.yaml</code></td>
  <td markdown="1"> 
  {{< markdownify >}}
  The analysis options file. For details, see [Customize Static Analysis.][]
  {{< /markdownify >}}
  </td>
</tr><tr>
  <td><code>pubspec.yaml</code></td>
  <td markdown="1"> 
  {{< markdownify >}}
  The file that describes this Dart package (the app) and its dependencies. For details, see [Pubspec Format.][]
  {{< /markdownify >}}
  </td>
</tr>
</table>

## What's next

In the [next tutorial page]({{< ref toh-1 >}}),
you'll modify the starter app to display more interesting data,
and to allow the user to edit that data.

[Customize Static Analysis.]: {{< param www >}}/guides/language/analysis-options
[Pubspec Format.]: {{< param www >}}/tools/pub/pubspec
