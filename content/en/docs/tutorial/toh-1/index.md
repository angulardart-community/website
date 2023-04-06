---
title: "1. The Hero Editor"
description: "Build a simple hero editor."
lead: ""
date: 2023-03-29T22:54:47-04:00
lastmod: 2023-03-29T22:54:47-04:00
draft: false
images: []
menu:
  docs:
    parent: "tutorial"
    identifier: "toh-1"
weight: 220
toc: true
excerptbase: "toh-1"
---

In this part of the tutorial, you'll modify the starter app to display
information about a hero. Then you'll add the ability to edit the hero's data.
When you're done, the app should look like this {{< exref toh-1 >}}.

## Where you left off

Before you start writing code, let's verify that you have the following structure. If not, you'll need to go back and follow the [setup]({{< ref toh-0 >}}) instructions
on the previous page.

<div class="ul-filetree">
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

<!-- {% include_relative _keep-app-running.md %} -->

## Show the hero

Make the following changes to `AppComponent`:

- Add a `hero` property for a hero named Windstorm.
- Add a `title` property initialized as shown below.
- Drop the `name` property.

{{< excerpt src="lib/app_component_1.dart" section="class" >}}

### Add multi-line template HTML

Update the template parameter in the `@Component` annotation with data bindings
to these new properties:

{{< excerpt src="lib/app_component_1.dart" section="template" >}}

<!-- <i class="material-icons">open_in_browser</i> -->

**Refresh the browser.** The app displays the title and hero name.

The double curly braces are Angular's [interpolation syntax][]. These
interpolation bindings present the component's `title` and `hero` property
values, as strings, inside the HTML header tags.

{{< alert context="info" >}}
Read more about interpolation in the [Displaying Data]({{< ref displaying-data >}}) page.
{{< /alert >}}

### Create a _Hero_ class

Create a `Hero` class with `id` and `name` properties and
save it to the following new file:

{{< excerpt src="lib/hero.dart" >}}

Make these changes to `app_component.dart`:

- Import `hero.dart`.
- In the `AppComponent` class, declare the type of `hero` to be `Hero`, and
  initialize it with a new `Hero` having an ID of `1` and the name "Windstorm".

{{< excerpt src="lib/app_component_2.dart" section="import-and-class" >}}

Because you changed the hero from a string to an object, update the binding in
the template to refer to the hero's `name` property.

{{< excerpt src="lib/app_component_2.dart" section="template" >}}

<!-- TODO: open in browser icon <i class="material-icons">open_in_browser</i>
**Refresh the browser.** The app continues to display the hero's name. -->

### Show all hero properties

Update the template to show all of the hero's properties: add a `<div>` for the
hero's `id` property and another `<div>` for the hero's `name`.

{{< excerpt src="lib/app_component_2.dart" section="template" >}}

<!-- <i class="material-icons">open_in_browser</i> -->
**Refresh the browser.** The app shows all the hero's details.

## Enable editing the hero name

Users should be able to edit the hero name in an `<input>` textbox.
The textbox should both _display_ the hero's `name` property
and _update_ that property as the user types.

You need a two-way binding between the `<input>` form element and the `hero.name` property.

### Use a two-way binding

Refactor the hero name in the template so it looks like this:

{{< excerpt src="lib/app_component.dart" section="template" >}}

`[(ngModel)]` is the Angular syntax to bind the `hero.name` property
to the textbox.
Data flows _in both directions:_ from the property to the textbox,
and from the textbox back to the property.

{{< alert context="info" >}}
  Read more about `ngModel` in the
  [Forms]({{< ref forms >}}#ngModel) and
  [Template Syntax]({{< ref template-syntax >}}#ngModel) pages.
{{< /alert >}}

## Declare non-core directives

Unfortunately, immediately after this change, the **app breaks**!

### Template parse error

<!-- <i class="material-icons">open_in_browser</i> -->
If you **refresh the browser,** the app won't load.
To know why, look at the [webdev serve][] output. The template
compiler doesn't recognize `ngModel`, and issues a parse error for
`AppComponent`:

```nocode
  Error running TemplateGenerator for forms|lib/src/hero_form_component.dart.
  Error: Template parse errors:
  Can't bind to 'ngModel' since it isn't a known native property or known directive. Please fix typo or add to directives list.
  [(ngModel)]="hero.name"
  ^^^^^^^^^^^^^^^^^^^^^^^
```

### Update the pubspec

<!-- <?code-excerpt path-base="examples/ng/doc"?> -->

The `ngforms` (used to be called `angular_forms`) library comes in its own package. Add the package to the pubspec dependencies:

<?code-excerpt "toh-0/pubspec.yaml" diff-with="toh-1/pubspec.yaml" from="dependencies" to="ngforms"?>
```diff
--- toh-0/pubspec.yaml
+++ toh-1/pubspec.yaml
@@ -8,2 +8,3 @@
 dependencies:
   ngdart: ^7.1.1
+  ngforms: ^4.1.1
```
{{< alert context="danger" >}}
Run `dart pub add ngforms` directly. The package version here may be out-to-date.
{{< /alert >}}

<!-- <?code-excerpt path-base="examples/ng/doc/toh-1"?> -->

### Add _@Component(directives: ...)_ {#component-directives}

Although `NgModel` is a valid Angular directive defined in the [ngforms][]
library, it isn't available by default.

Before you can use any Angular directives in a template,
you need to list them in the `directives` argument of your component's
`@Component` annotation. You can add directives individually, or for
convenience you can add the [formDirectives][] list
(note the new import statement):

{{< excerpt src="lib/app_component.dart" section="directives" >}}

<i class="material-icons">open_in_browser</i> **Refresh the browser** and the
app should work again. You can edit the hero's name and see the changes
reflected immediately in the `<h2>` heading above the textbox.

## The road you've travelled

Take stock of what you've built.

* The Tour of Heroes app uses the double curly braces of interpolation (a type of one-way data binding)
  to display the app title and properties of a `Hero` object.
* You wrote a multi-line template using Dart's template strings to make the template readable.
* You added a two-way data binding to the `<input>` element
  using the built-in `ngModel` directive. This binding both displays the hero's
  name and allows users to change it.
* You added [formDirectives][] to the `directives` argument of the app's
  `@Component` annotation so that Angular knows where `ngModel` is defined.

Your app should look like this {% example_ref %}.

Here are the files that you created or modified:

{{< codetabs
    "lib/app_component.dart"
    "lib/hero.dart"
>}}

## The road ahead

In the [next tutorial page]({{< ref toh-2 >}}), you'll build on the Tour of Heroes app to display a list of heroes.
You'll also allow the user to select heroes and display their details.
You'll learn more about how to retrieve lists and bind them to the template.

[ngforms]: {{< param pubApi >}}/ngforms
[webdev serve]: {{< param pubPkg >}}/webdev#usage
[formDirectives]: {{< param pubApi >}}/ngforms/latest/ngforms/formDirectives-constant.html
[interpolation syntax]: {{< ref template-syntax >}}#interpolation
