---
title: Overview
description: How to read and use this documentation
draft: false
menu:
  docs:
    parent: "guide"
weight: 100
toc: true
---
This page describes the Angular documentation at a high level.
If you're new to Angular, you may want to visit [Learning Angular]({{< ref learning-angular >}}) first.

## Themes

The documentation is divided into major thematic sections, each
a collection of pages devoted to that theme.

<style>tr { vertical-align:top; }</style>

<table width="100%">
<col width="15%">
<col>
<tr>
  <td><b>Guide</b></td>
  <td markdown="1">
{{< markdownify >}}
Learn the Angular basics (you're already here!) like the
[setup]({{< ref setup >}}) for local development,
[displaying data]({{< ref displaying-data >}}) and
accepting [user input]({{< ref user-input >}}),
building simple [forms]({{< ref forms >}}),
[injecting app services]({{< ref dependency-injection >}}) into components,
and using Angular's [template syntax]({{< ref template-syntax >}}).
{{< /markdownify >}}
  </td>
</tr>
<tr>
  <td><b><a href="{{< ref tutorial >}}">Tutorial</a></b></td>
  <td markdown="1">
{{< markdownify >}}
A step-by-step, immersive approach to learning Angular that
introduces the major features of Angular in an app context.
{{< /markdownify >}}
  </td>
</tr>
<tr>
  <td><b><a href="{{< ref advanced >}}">Advanced</a></b></td>
  <td markdown="1">
{{< markdownify >}}
In-depth analysis of Angular features and development practices.
{{< /markdownify >}}
  </td>
</tr>
<tr>
  <td><b><a href="{{< ref api >}}">API Reference</a></b></td>
  <td markdown="1">
{{< markdownify >}}
Choose **All** from the **PACKAGES** dropdown to see APIs defined by the
Angular libraries and commonly used `dart:*` libraries.
{{< /markdownify >}}
  </td>
</tr>
</table>

A few early pages are written as tutorials and are clearly marked as such.
The rest of the pages highlight key points in code rather than explain each step necessary to build the sample.
You can always get the full source through the [sample repos]({{< param angularOrg >}}).

## Code samples

Each page includes code snippets from a sample app that accompanies the page.
You can reuse these snippets in your apps.

Look for a link to a running version of that sample, often near the top of the page,
such as this {{< exref architecture >}} from the [Architecture]({{< ref architecture >}}) page.

## Reference pages

* The [Glossary]({{< ref glossary >}}) defines terms that Angular developers should know.
* The [Cheat Sheet]({{< ref cheat-sheet >}}) lists Angular syntax for common scenarios.
* The [API Reference]({{< ref api >}}) is the authority on every public-facing
  member of the Angular libraries.

## Feedback

Please tell us about any issues you find:

* For **documentation and example** issues, use the
  [site-angulardart issue
  tracker]({{< param this >}}/issues).
* To report issues with **AngularDart** itself, use the
  [Angular issue tracker]({{< param angularRepo >}}/issues).
