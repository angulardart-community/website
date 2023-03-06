# The next AngularDart documentation site.

This will be the next-generation documentation for AngularDart, built with
[Hugo] and a modified version of the [Doks] theme. Compared to the
[older site](https://github.com/angulardart-community/site-angulardart), it's
much easier and quicker to build and iterate new content.

It's still very much WIP in the current state, namely to migrate all the Jekyll
templates to Hugo shortcodes. Follow
[#9](https://github.com/angulardart-community/website/issues/9) for this
progress. A better README
will be provided later.

## Build the site

Here are simple instructions if you want to hack on it now:

1. Install [Dart](https://dart.dev/get-dart) and NodeJS (>= 16.16.0, though an
  older version may also work, just remove the restriction in package.json).
2. (Optional) Run `npm install`. This is technically only needed if you don't
  have [Hugo] installed on your systemand you want to only serve the site
  locally using Hugo
  for testing.
3. Run `dart pub get` and `dart run build_runner build -o data/fragments` to
  generate code excerpts.
4. If you have [Hugo] installed on your system, you may run `hugo server`
  directly. If not, do step 2 and run `npm run server`.
5. Open `htttp://localhost:1313` (or the addresss Hugo shows you if you
  specified a
  custom address/port).
6. If you want to build the site, perform step 2 and run
  `npm run build:preview`. **DON'T** run
  `npm run build` or `hugo build`. The site's baseurl won't be setup correctly.
  These options are for release builds. The result will rest inside the
  `public/` folder. Use your favorite http server to serve it (e.g.
  `dhttpd --path public`).

If you're familiar with the old site, you might be surprised that no git
submodules are required. Yes indeed, we're using `git subtree`! You may want to
check out if subtree suits your purposes if you're also annoyed by / struggling
with submodules.

## Made possible by

- [Hugo].
- The [Doks] theme.

Thank you so much to all of the maintainers and contributors of these projects!

[Hugo]: https://gohugo.io
[Doks]: https://getdoks.org
