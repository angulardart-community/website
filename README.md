# The next AngularDart documentation site.

This will be the next-generation documentation for AngularDart, built with
[Hugo] and a modified version of the [Doks] theme.

It's still very much WIP in the current state, namely to migrate all the Jekyll
templates to Hugo shortcodes. A better README will be provided later.

## Build the site

Here are simple instructions if you want to hack on it now:

1. Install [Dart](https://dart.dev/get-dart) and NodeJS (>= 16.16.0, though an
  older version may also work, just remove the restriction in package.json).
2. (Optional) Run `npm install`. This is technically only needed if you don't
  have [Hugo] installed on your systemand you want to only serve the site
  locally using Hugo
  for testing.
3. If you have [Hugo] installed on your system, you may run `hugo server`
  directly. If not, do step 2 and run `npm run server`.
4. Open `htttp://localhost:1313` (or the addresss Hugo shows you if you
  specified a
  custom address/port).
5. If you want to build the site, perform step 2 and run
  `npm run build:preview`. **DON'T** run
  `npm run build` or `hugo build`. The site's baseref won't be setup correctly.
  These options are for release builds.

## Made possible by

- [Hugo].
- The [Doks] theme.

Thank you so much to all of the maintainers and contributors of these projects!

[Hugo]: https://gohugo.io
[Doks]: https://getdoks.org