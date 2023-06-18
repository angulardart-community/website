---
title: "Deployment"
description: "Learn how to build and serve your AngularDart web app."
date: 2023-06-17T19:55:02-04:00
draft: false
images: []
menu:
  docs:
    parent: "advanced"
    identifier: "deployment"
weight: 320
toc: true
---

Deploying an AngularDart web app is similar to deploying any other web app:
you first need to compile the app to JavaScript.
This page describes how to compile your app—with
tips for making it smaller and faster—and
points you to resources for serving the app.

## Building your app {#compiling-to-javascript}

Use the webdev tool to build your app,
compiling it to JavaScript and generating all the assets
you need for deployment.
When you build using [dart2js][],
you get a JavaScript file that's reasonably small,
thanks to the dart2js compiler's support for tree shaking.

With a little extra work, you can make your deployable app
[smaller, faster, and more reliable](#make-your-app-smaller-faster-and-more-reliable).

### Compile using webdev

[Use the **webdev build** command][build] to create
a deployable version of your app.
Here's what happens when you use webdev with dart2js
and the `--output build` option:

* Deployable files appear under your app's `build` directory.
* dart2js compiles your app to JavaScript, saving the result
  in the file `build/main.dart.js`.

For more information, see the [documentation for webdev][webdev].

### Use dart2js flags to produce better JavaScript

Google's apps often use the following [dart2js options]({{< param dartlang >}}/tools/dart2js#options):

- `--fast-startup`
- `--minify`
- `--trust-primitives`
- `--omit-implicit-checks`

**Test your apps before deploying with these options!**

- Build your app both with and without `--fast-startup`,
  so you can judge whether the speedup is worth the increase in JavaScript size.
- The `--trust-primitives` option can have unexpected results
  (even in well-typed code) if your data isn't always valid.

For more information, see the [documentation for dart2js][dart2js].

{{< alert context="warning" >}}
  **Important:**
  Make sure your app has good [test coverage]({{< ref testing >}})
  before you use either of the `--trust-*` or `--omit-*` options.
  If some code paths aren't tested,
  your app might run in dartdevc but
  misbehave when compiled using dart2js.
{{< /alert >}}

You can specify dart2js options in a build config file,
as described in the [build_web_compilers] README.

### Make your app smaller, faster, and more reliable

The following steps are optional,
but they can help make your app more reliable and responsive.

- [Building your app / Compiling to JavaScript](#compiling-to-javascript)
  - [Compile using webdev](#compile-using-webdev)
  - [Use dart2js flags to produce better JavaScript](#use-dart2js-flags-to-produce-better-javascript)
  - [Make your app smaller, faster, and more reliable](#make-your-app-smaller-faster-and-more-reliable)
    - [Use the pwa package to make your app work offline](#use-the-pwa-package-to-make-your-app-work-offline)
    - [Use deferred loading to reduce your app's initial size](#use-deferred-loading-to-reduce-your-apps-initial-size)
    - [Follow best practices for web apps](#follow-best-practices-for-web-apps)
    - [Remove unneeded build files](#remove-unneeded-build-files)
- [Serving your app](#serving-your-app)
  - [Angular-specific tips](#angular-specific-tips)
  - [GitHub Pages](#github-pages)
  - [Firebase](#firebase)


#### Use the pwa package to make your app work offline

{{< alert context="danger" >}}
The `pwa` package is very outdated. Please consider using other options for
creating a PWA app.
{{< /alert >}}

The [pwa package](https://pub.dev/packages/pwa) simplifies the task of
making your app work with limited or no connectivity.
For information on using this package, see
[Making a Dart web app offline-capable: 3 lines of code.](https://medium.com/dartlang/making-a-dart-web-app-offline-capable-3-lines-of-code-e980010a7815)


#### Use deferred loading to reduce your app's initial size

You can use Dart's support for deferred loading to
reduce your app's initial download size.
For details, see the language tour's coverage of
[deferred loading]({{site.www}}/guides/language/language-tour#lazily-loading-a-library)
and the dart-lang/angular page
[Imperative Component Loading.](https://github.com/dart-lang/angular/blob/master/doc/faq/component-loading.md)


#### Follow best practices for web apps

The usual advice for web apps applies to AngularDart web apps.
Here are a few resources:

* [Web Fundamentals](https://developers.google.com/web/fundamentals/) (especially [Optimizing Content Efficiency](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/))
* [Progressive Web Apps](https://developers.google.com/web/progressive-web-apps/)
* [Lighthouse](https://developers.google.com/web/tools/lighthouse/)


#### Remove unneeded build files

Web compilers can produce files that are useful during development,
such as Dart-to-JavaScript map files,
but unnecessary in production.

To remove these files, you can run a command like the following:

<!--
TODO: Revise the following once https://github.com/dart-lang/angular/issues/1123 is resolved:
!-->

```bash
# From the root directory of your app:
find build -type f -name "*.js.map" -exec rm {} +
```

## Serving your app

You can serve your AngularDart app just like you'd serve any other web app.
This section points to tips for serving Angular apps,
as well as Dart-specific resources to help you use GitHub Pages or Firebase
to serve your app.


### Angular-specific tips

For information on changes you might have to make to the server, see the
[Server configuration](https://angular.io/guide/deployment#server-configuration)
section of the Angular TypeScript deployment documentation.


### GitHub Pages

If your app doesn't use routing or require server-side support,
you can serve the app using [GitHub Pages](https://pages.github.com/).
The [peanut][] package is
an easy way to automatically produce a gh-pages branch for any Dart web app.

The [startup_namer example](https://filiph.github.io/startup_namer/)
is hosted using GitHub Pages.
Its files are in the **gh-pages** branch of the
[filiph/startup_namer repo](https://github.com/filiph/startup_namer)
and were built using [peanut].


### Firebase

AngularDart and Firebase resources:

* The Google I/O 2017 codelab
  [Build an AngularDart & Firebase Web App](https://codelabs.developers.google.com/codelabs/angulardart-firebase-web-app/)
  walks through using Firebase for server-side communication,
  but doesn't include instructions for serving the app.
* The [Firebase Hosting documentation](https://firebase.google.com/docs/hosting/)
  describes how to deploy web apps with Firebase.
* In the Firebase Hosting documentation,
  [Customize Hosting Behavior](https://firebase.google.com/docs/hosting/url-redirects-rewrites)
  covers redirects, rewrites, and more.

[build]: {{< param dartlang >}}/tools/webdev#build
[build_runner]: {{< param dartlang >}}/tools/build_runner
[build_web_compilers]: {{< param pubPkg >}}/build_web_compilers
[config]: {{< param dartlang >}}/tools/build_runner#config
[dart2js]: {{< param dartlang >}}/tools/dart2js
[dartdevc]: {{< param dartlang >}}/tools/dartdevc
[peanut]: {{< param pubPkg >}}/peanut
[webdev]: {{< param dartlang >}}/tools/webdev
