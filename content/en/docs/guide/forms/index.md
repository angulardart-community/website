---
title: Forms
description: A form creates a cohesive, effective, and compelling data entry experience. An Angular form coordinates a set of data-bound user controls, tracks changes, validates input, and presents errors.
draft: false
menu:
  docs:
    parent: "guide"
weight: 160
toc: true
excerptbase: forms
---

Forms are the mainstay of business apps.
You use forms to log in, submit a help request, place an order, book a flight,
schedule a meeting, and perform countless other data-entry tasks.

In developing a form, it's important to create a data-entry experience that guides the
user efficiently and effectively through the workflow.

Developing forms requires design skills (which are out of scope for this page), as well as framework support for
*two-way data binding, change tracking, validation, and error handling*,
which you'll learn about on this page.

This page shows you how to build a simple form from scratch. Along the way you'll learn how to:

* Build an Angular form with a component and template.
* Use `ngModel` to create two-way data bindings for reading and writing input-control values.
* Track state changes and the validity of form controls.
* Provide visual feedback using special CSS classes that track the state of the controls.
* Display validation errors to users and enable/disable form controls.
* Share information across HTML elements using template reference variables.

You can run the {{< exref forms >}} in Plunker and download the code from there.

## Template-driven forms

You can build forms by writing templates in the Angular [template syntax]({{< ref template-syntax >}}) with
the form-specific directives and techniques described in this page.

{{< alert >}}
You can also use a reactive (or model-driven) approach to build forms.
However, this page focuses on template-driven forms.
{{< /alert>}}

You can build almost any form with an Angular template&mdash;login forms, contact forms, and pretty much any business form.
You can lay out the controls creatively, bind them to data, specify validation rules and display validation errors,
conditionally enable or disable specific controls, trigger built-in visual feedback, and much more.

Angular makes the process easy by handling many of the repetitive, boilerplate tasks you'd
otherwise wrestle with yourself.

You'll learn to build a template-driven form that looks like this:

{{< figure src="hero-form.png" caption="Clean Form" alt="Clean Form" width="360">}}

The *Hero Employment Agency* uses this form to maintain personal information about heroes.
Every hero needs a job. It's the company mission to match the right hero with the right crisis.

Two of the three fields on this form are _required_.
Following [material design guidelines](https://material.io/components/text-fields),
required fields have an asterisk (*).

If you delete the hero name, the form displays a validation error in an attention-grabbing style:

{{< figure src="hero-form-name-required.png" caption="Invalid, Name Required"
alt="Invalid, Name Required" width="360" >}}

Note that the *Submit* button is disabled, and the input control changes from green to red.

You'll build this form in small steps:

1. Create the `Hero` model class.
1. Create the component that controls the form.
1. Create a template with the initial form layout.
1. Bind data properties to each form control using the [ngModel][NgModel]
   two-way data-binding syntax.
1. Add an [ngControl][NgControl] directive to each form-input control.
1. Add custom CSS to provide visual feedback.
1. Show and hide validation-error messages.
1. Handle form submission with *ngSubmit*.
1. Disable the form’s *Submit* button until the form is valid.

## Setup

Follow the [setup]({{< ref setup >}}) instructions to create a new project named `forms`.

### Add angular_forms

<?code-excerpt path-base="examples/ng/doc"?>

The Angular forms functionality is in the [ngforms][] library, which
comes in [its own package][ngforms@pub]. Add the package to the pubspec
dependencies:

<?code-excerpt "quickstart/pubspec.yaml" diff-with="forms/pubspec.yaml" from="dependencies" to="angular_forms"?>
```diff
--- quickstart/pubspec.yaml
+++ forms/pubspec.yaml
@@ -8,2 +8,3 @@
 dependencies:
-  angular: ^7.0.2
+  angular: ^6.0.1
+  angular_forms: ^3.0.0
```

<?code-excerpt path-base="examples/ng/doc/forms"?>

## Create a model

As users enter form data, you'll capture their changes and update an instance of a model.
You can't lay out the form until you know what the model looks like.

A model can be as simple as a "property bag" that holds facts about a thing of importance for the app.
That describes well the `Hero` class with its three required fields (`id`, `name`, `power`)
and one optional field (`alterEgo`).

In the `lib` directory, create the following file with the given content:

{{< excerpt src="lib/src/hero.dart" >}}

It's an anemic model with few requirements and no behavior, good enough for the demo.

The `alterEgo` is optional, so the constructor lets you omit it;
note the brackets in `[this.alterEgo]`.

You can create a new hero like this:

{{< excerpt src="lib/src/hero_form_component.dart" section="SkyDog" >}}

## Create a basic form

An Angular form has two parts: an HTML-based _template_ and a component _class_
to handle data and user interactions programmatically.
Begin with the class because it states, in brief, what the hero editor can do.

### Create a form component

Create the following file with the given content:

{{< excerpt src="lib/src/hero_form_component.dart" section="v1" >}}

There’s nothing special about this component, nothing form-specific,
nothing to distinguish it from any component you've written before.

Understanding this component requires only the Angular concepts covered in previous pages.

- The code imports the main Angular library and the `Hero` model you just created.
- The `@Component` selector value of `hero-form` means you can drop this form
  in a parent template with a `<hero-form>` element.
- The `templateUrl` property points to a separate file (which
  [you'll create shortly](#create-an-initial-form-template))
  for the template HTML.
- You defined mock data for `model` and `powers`.

Down the road, you can inject a data service to get and save real data
or perhaps expose these properties as inputs and outputs
(see [Input and output properties]({{< ref template-syntax >}}#inputs-outputs) in the
[Template Syntax]({{< ref template-syntax >}}) page) for binding to a
parent component. This is not a concern now and these future changes won't affect the form.

### Revise the app component

`AppComponent` is the app's root component. It will host the `HeroFormComponent`.

Replace the contents of the starter app version with the following:

{{< excerpt src="lib/app_component.dart" >}}

### Create an initial form template

Create the template file with the following contents:

{{< excerpt src="lib/src/hero_form_component_1.html" section="start" >}}

The language is simply HTML5. You're presenting two of the `Hero` fields, `name` and `alterEgo`, and
opening them up for user input in input boxes.

The *Name* `<input>` control has the HTML5 `required` attribute;
the *Alter Ego* `<input>` control does not because `alterEgo` is optional.

You added a *Submit* button at the bottom with some classes on it for styling.

*You're not using Angular yet*. There are no bindings or extra directives, just layout.

{{< alert >}}
In template driven forms, if you've imported the `ngforms` library, you don't have to do anything
to the `<form>` tag in order to make use of the library capabilities. Continue on to see how this works.
{{< /alert>}}

<!-- TODO: import material icons <i class="material-icons">open_in_browser</i> -->
**Refresh the browser.** You'll see a simple, unstyled form.

### Style the form

The general CSS classes `container` and `btn` come from [Bootstrap][].
Bootstrap also has [form-specific classes][Bootstrap forms] including `form-control` and `form-group`.
Together, these give the form a little style.

{{< alert >}}
Angular makes no use of Bootstrap classes or
the styles of any external library. Angular apps can use any CSS library or none at all.
{{< /alert >}}

Add Bootstrap styles by inserting the following link to the `<head>` of `index.html`:

{{< excerpt src="web/index.html" section="bootstrap" >}}

<!-- TODO: material icon <i class="material-icons">open_in_browser</i> -->
**Refresh the browser.** You'll see a form with style!

## Add powers with _*ngFor_

The hero must choose one superpower from a fixed list of agency-approved powers.
You maintain that list internally (in `HeroFormComponent`).

You'll add a `select` to the
form and bind the options to the `powers` list using `ngFor`,
a technique seen previously in the [Displaying Data]({{< ref displaying-data >}}) page.

Add the following HTML *immediately below* the *Alter Ego* group:

{{< excerpt src="lib/src/hero_form_component_1.html" section="powers" >}}

This code repeats the `<option>` tag for each power in the list of powers.
The `p` template input variable is a different power in each iteration;
you display its name using the interpolation syntax.

<a id="ngModel"></a>
## Two-way data binding with _ngModel_

<!-- TODO: material icons <i class="material-icons">open_in_browser</i> -->
**Running the app** now is a bit disappointing.

{{< figure src="hero-form-wo-bindings.png" caption="Early form with no binding"
alt="Early form with no binding" width="360" >}}

You don't see hero data because you're not binding to the `Hero` yet.
You know how to do that from earlier pages.
[Displaying Data]({{< ref displaying-data >}}) teaches property binding.
[User Input]({{< ref user-input >}}) shows how to listen for DOM events with an
event binding and how to update a component property with the displayed value.

Now you need to display, listen, and extract at the same time.

You could use the techniques you already know, but
instead you'll use the new `[(ngModel)]` syntax, which
makes binding the form to the model easy.

Find the `<input>` tag for *Name* and update it like this:

{{< excerpt src="lib/src/hero_form_component_2.html" section="name" >}}

<div class="l-sub-section" markdown="1">
  You added a diagnostic interpolation before the form-group
  so you can see what you're doing.
  You left yourself a note to throw it away when you're done.
</div>

Focus on the binding syntax: `[(ngModel)]="..."`.

<!-- TODO: material icon <i class="material-icons">open_in_browser</i> -->
**Run the app** now and type in the *Name* input,
adding and deleting characters. You'll see the characters appear and disappear
from the diagnostic text. At some point it might look like this:

{{< figure src="name-ngmodel.png" caption="Name ngModel" alt="Name ngModel"
width="300" >}}

The diagnostic is evidence that values really are flowing from the input to the model and
back again.

{{< alert context="info" >}}
That's *two-way data binding*.
For more information, see
[Two-way binding with NgModel](template-syntax#ngModel) on the
the [Template Syntax](template-syntax) page.
{{< /alert >}}

Notice that you also added an `ngControl` directive to the `<input>` tag and set it to "name",
which makes sense for the hero's name. Any unique value will do, but using a descriptive name is helpful.
Defining an `ngControl` directive is a requirement when using `[(ngModel)]` in combination with a form.

{{< alert context="info" >}}
Internally, Angular creates `NgFormControl` instances and
registers them with an `NgForm` directive that Angular attached to the `<form>` tag.
Each `NgFormControl` is registered under the name you assigned to the `ngControl` directive.
You'll read more about `NgForm` [later in this guide](#ngForm).
{{< /alert >}}

Add similar `[(ngModel)]` bindings and `ngControl` directives to *Alter Ego* and *Hero Power*.

Replace the diagnostic binding expression with `model`. This way you can
confirm that two-way data binding works for the *entire hero model*.

After revision, the core of the form should look like this:

{{< excerpt src="lib/src/hero_form_component_3.html" section="controls" >}}

{{< alert >}}
- Each input element has an `id` property that is used by the `label` element's `for` attribute
  to match the label to its input control.
- Each input element has a `ngControl` directive that is required by Angular forms to register the control with the form.
{{< /alert >}}

If you run the app now and change every hero model property, the form might display like this:

{{< figure src="ngmodel.png" caption="ngModel" alt="ngModel" width="460" >}}

The diagnostic near the top of the form
confirms that all of your changes are reflected in the model.

**Delete** the diagnostic binding from the template since it has served its purpose.

## Give visual feedback based on control state

Using CSS and class bindings, you can change a form control's appearance to reflect its state.

### Track control state

An Angular form control can tell you if the user touched the control, if the
value changed, or if the value became invalid.

Each control ([NgControl][]) in an Angular form tracks its own state and makes the state
available for inspection through the following field members:

- `dirty` and `pristine` indicate whether the control's _value has changed_.
- `touched` and `untouched` indicate whether the control has been _visited_.
- `valid` reflects the control value's _validity_.

### Style controls

The `valid` control property is the most interesting, because you want to send a
strong visual signal when a control value is invalid.
To create such visual feedback, you'll use the
[Bootstrap custom-forms][] classes `is-valid` and `is-invalid`.

Add a [template reference variable]({{< ref template-syntax >}}#ref-vars) called `name`
to the _Name_ `<input>` tag. Use `name` and [class bindings][class binding]
to conditionally assign the appropriate form validity class.

Temporarily add another template reference variable named `spy`
to the _Name_ `<input>` tag and use it to display the input's CSS classes.

{{< excerpt src="lib/src/hero_form_component_4.html" section="name" >}}

{{< alert context="info" >}}
#### Template reference variables
The `spy` [template reference variable](template-syntax#ref-vars) gets bound to the
`<input>` DOM element, whereas the `name` variable (through the `#name="ngForm"` syntax)
gets bound to the [NgModel]({{< param pubApi >}}/ngforms/latest/angular_forms/NgModel-class.html)
associated with the input element.

Why "ngForm"?  A [Directive]({{< param pubApi >}}/ngdart/latest/di/Directive-class.html)'s
[exportAs]({{< param pubApi >}}/ngdart/latest/di/Directive/exportAs.html) property tells Angular
how to link the reference variable to the directive. You set `name` to "ngForm"
because the [ngModel]({{< param pubApi >}}/ngdart/latest/angular_forms/NgModel-class.html)
directive's `exportAs` property is "ngForm".
{{< /alert >}}

<!-- TOOD: material icon <i class="material-icons">open_in_browser</i> -->
**Refresh the browser,** and follow these steps:

1. Look at the _Name_ input.
   - It has a green border.
   - Its has the classes `form-control` and  `is-valid`.
2. Change the name by adding some characters. The classes remain the same.
3. Delete the name.
   - The input box border turns red.
   - The `is-invalid` class replaces `is-valid`.

**Delete** the `#spy` template reference variable and the diagnostic that uses it.

As an alternative to class bindings, you can use an [NgClass][]
directive to style a control. First, add the following method to set a
control's state-dependent CSS class names:

{{< excerpt src="lib/src/hero_form_component.dart" section="setCssValidityClass" >}}

Use the map value returned by this method to bind to the [NgClass][] directive
&mdash; read more about this directive and its alternatives in the
[template syntax](template-syntax#ngClass) page.

{{< excerpt src="lib/src/hero_form_component.html" section="power" >}}

## Show and hide validation error messages

You can improve the form. The _Name_ input is required, and clearing it turns the box outline red.
That says something is wrong but the user doesn't know *what* is wrong or what to do about it.
Leverage the control's state to reveal a helpful message.

### Use the valid and pristine states

When the user deletes the name, the form should look like this:

{{< figure src="name-required-error.png" alt="Name required" width="300" >}}

To achieve this effect, add the following `<div>` immediately after the _Name_ `<input>`:

{{< excerpt src="lib/src/hero_form_component.html" section="hidden-error-message" >}}

<!-- TODO: material icon <i class="material-icons">open_in_browser</i> -->
**Refresh the browser** and delete the _Name_ input. The error message is displayed.

You control visibility of the error message by setting the [hidden][] attribute
of the `<div>` based on the state of the `name` control.

In this example, you hide the message when the control is valid or pristine
&mdash; "pristine" means the user hasn't changed the value since it was displayed in
this form.

{{< alert >}}
#### User experience is the developer's choice

Some developers want the message
to display at all times.  If you ignore the `pristine` state, you would hide the
message only when the value is valid. If you arrive in this component with a
new (blank) hero or an invalid hero, you'll see the error message immediately,
before you've done anything.

Some developers want the message to display only when the user makes an invalid
change.  Hiding the message while the control is "pristine" achieves that goal.
You'll see the significance of this choice when you [add a _Clear_ button](#add-a-_clear_-button)
to the form.
{{< /alert >}}

The hero *Alter Ego* is optional so you can leave that be.

Hero *Power* selection is required. You can add the same kind of error message
to the `<select>` if you want, but it's not imperative because the selection box
already constrains the power to valid values.

## Add a _Clear_ button

### Resetting the model

Add a `clear()` method to the component class:

{{< excerpt src="lib/src/hero_form_component.dart" section="clear" >}}

Add a _Clear_ button with a `click` event binding, right after the *Submit* button:

{{< excerpt src="lib/src/hero_form_component_4.html" section="Clear-button" >}}

<!-- TODO: material icon <i class="material-icons">open_in_browser</i> -->
**Refresh the browser.** Click the _Clear_ button. The text fields go blank,
and if you've changed the power, it reverts to its default value.

<!-- {% if false %}
{% comment %}
Skipping this for now since Angular doesn't yet support resetting forms
(https://github.com/dart-lang/angular/issues/216), and it isn't clear
that this is necessary
{% endcomment %} -->

Notice how the _Name_ control is red, indicating an invalid `name` property.
No error message is showing because the form is pristine &mdash;
you haven't changed anything yet.

Enter a name and click *Clear* again. The app displays the "Name is required"
error message. You don't want error messages when you clear the model.
Why are you getting one now?

Inspecting the element in the browser tools reveals that the *Name* input is
_no longer pristine_. The form remembers that you entered a name before
clicking *Clear*. Replacing the hero object *did not restore the pristine
state* of the form controls.

### Resetting the form

You have to clear all of the control values and flags imperatively,
which you can do by calling the `NgForm.reset()` method.
Replace the component `clear()` method call by a form reset:

{{< alert context="warning" >}}
`NgForm.reset()` may not be supported yet: https://github.com/dart-lang/angular/issues/216.
{{< /alert >}}

{{< excerpt src="lib/src/hero_form_component_5.html" section="Clear-button" >}}

Because of the two-way bindings, resetting the form clears the model.

<!-- TODO: material icon <i class="material-icons">open_in_browser</i> -->
**Refresh the browser.** Clicking _Clear_ now resets the form, its control flags,
and the model.

{{< alert >}}
You don't need the component `clear()` method anymore, so you can delete it.
{{< /alert >}}

## Submit the form with _ngSubmit_

The user should be able to submit this form after filling it in.
The *Submit* button at the bottom of the form
does nothing on its own, but it will
trigger a form submit because of its type (`type="submit"`).

A form submit is useless at the moment. To make it useful, assign
form component's `onSubmit()` method to the form's `ngSubmit` event binding:

{{< excerpt src="lib/src/hero_form_component.html" section="ngSubmit" >}}

Note the template reference variable `#heroForm`.
As was [explained earlier](#template-reference-variables),
the variable `heroForm` gets bound to the `NgForm` directive that governs the form as a whole.

{{< alert context="info" >}}
#### The `NgForm` directive

Angular automatically creates and attaches an [NgForm][]  directive to the `<form>` tag.

The `NgForm` directive supplements the `form` element with additional features.
It holds the controls you created for the elements with `ngModel` and `ngControl` directives,
and monitors their properties, including their validity.
{{< /alert >}}

You'll bind the form's overall validity via
the `heroForm` variable to the button's `disabled` property:

{{< excerpt src="lib/src/hero_form_component.html" section="Submit-button">}}

<!-- TODO: material icon <i class="material-icons">open_in_browser</i> -->
**Refresh the browser.** You'll find that the button is enabled&mdash;although
it doesn't do anything useful yet.

Now if you delete the Name, you violate the "required" rule, which
is duly noted in the error message.
The *Submit* button is also disabled.

Not impressed?  Think about it for a moment. What would you have to do to
wire the button's enable/disabled state to the form's validity without Angular's help?

For you, it was as simple as this:

1. Define a template reference variable on the (enhanced) form element.
2. Refer to that variable in a button many lines away.

## Display the model (optional)

Submitting the form has no visual effect at the moment.

{{< alert >}}
As can be expected for a demo.
Jazzing up the demo won't teach you anything new about forms.
But this is an opportunity to exercise some of your newly won
binding skills.
If you aren't interested, skip to this page's [summary](#summary).
{{< /alert >}}

As a visual effect, you can hide the data entry area and display something else.

Wrap the form in a `<div>` and bind
its `hidden` property to the `HeroFormComponent.submitted` property.

{{< excerpt src="lib/src/hero_form_component.html" section="edit-div" >}}

The form is visible from the start because the
`submitted` property is false until you submit the form,
as this fragment from the `HeroFormComponent` shows:

{{< excerpt src="lib/src/hero_form_component.dart" section="submitted" >}}

Now add the following HTML below the `<div>` wrapper you just wrote:

{{< excerpt src="lib/src/hero_form_component.html" section="submitted" >}}

<!-- TODO: material icon <i class="material-icons">open_in_browser</i> -->
**Refresh the browser,** and submit the form.
The `submitted` flag becomes true and the form disappears.
You'll see the hero model values (read-only) displayed in a table.

{{< figure src="submitted-hero-data.png" caption="Clean Form" alt="Clean Form"
width="360" >}}

The view includes an *Edit* button whose click event binding clears the `submitted` flag.
When you click the *Edit* button, the table disappears and the editable form reappears.

## Summary

Angular forms provide support for data modification, validation, and more.
In this page, you learned how to use the following features:

- An HTML form template, and a form component class with an `@Component` annotation.
- Form submission, handled through an `ngSubmit` event binding.
- Template reference variables, such as `heroForm` and `name`.
- Two-way data bindings (`[(ngModel)]`).
- `NgControl` directives for validation and form-element change tracking.
- The `valid` property of input controls
  (accessed through template reference variables),
  for checking control validity and showing/hiding error messages.
- [NgForm.form][] validity to set the *Submit* button's enabled state.
- Custom CSS classes to provide visual feedback to users about control state.

The final project folder structure should look like this:

<!-- TODO: display it like a tree format -->
{{< alert >}}
- angular_forms
  - lib
    - app_component.dart
    - src
      - hero.dart
      - hero_form_component.{dart,html}
  - web
    - index.html
    - main.dart
    - styles.css
  - pubspec.yaml
{{< /alert >}}

Here’s the code for the final version of the app:

{{< codetabs 
    "lib/app_component.dart"
    "lib/src/hero.dart"
    "lib/src/hero_form_component.dart"
    "lib/src/hero_form_component.html"
    "web/index.html"
    "web/main.dart"
>}}
<!-- <code-tabs>
  <?code-pane "lib/app_component.dart" linenums?>
  <?code-pane "lib/src/hero.dart" linenums?>
  <?code-pane "lib/src/hero_form_component.dart" region="final" linenums?>
  <?code-pane "lib/src/hero_form_component.html" linenums?>
  <?code-pane "web/index.html" linenums?>
  <?code-pane "web/main.dart" linenums?>
</code-tabs> -->

[ngforms]: {{< param pubApi >}}/angular_forms/latest/angular_forms/angular_forms-library.html
[ngforms@pub]: https://pub.dev/packages/angular_forms
[Bootstrap]: https://getbootstrap.com
[Bootstrap forms]: https://getbootstrap.com/docs/4.0/components/forms
[Bootstrap custom-forms]: https://getbootstrap.com/docs/4.0/components/forms/#custom-forms
[class binding]: {{< ref template-syntax >}}#class-binding
[hidden]: https://developer.mozilla.org/docs/Web/HTML/Global_attributes/hidden
[NgClass]: {{< param pubApi >}}/angular/latest/angular/NgClass-class.html
[NgControl]: {{< param pubApi >}}/ngforms/latest/angular_forms/NgControl-class.html
[NgControlStatus]: {{< param pubApi >}}/ngforms/latest/angular_forms/NgControlStatus-class.html
[NgForm]: {{< param pubApi >}}/ngforms/latest/angular_forms/NgForm-class.html
[NgForm.form]: {{< param pubApi >}}/ngforms/latest/angular_forms/AbstractNgForm/form.html
[NgModel]: {{< param pubApi >}}/ngforms/latest/angular_forms/NgModel-class.html
