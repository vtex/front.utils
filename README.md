# VTEX Front End Utils

Common extensions used by various projects

## Structure

This repo contains several directories under `src/`, each with common snippets, extensions or patterns used accross projects.

Usually, they are grouped by the framework or library that they extend, i.e. `angular`, `knockout`, `underscore`.

For easy access, you can expect that any given file will be exported to the global `window` under the following template:

`window.vtex.{directory}.{name}`

Sub-directories will be expanded into namespaces (i.e. `knockout/bindings/` will be available in `knockout.bidings`).

File names that are dashed (`my-file`) will be converted to camelCase (`myFile`).

For example, the `common/append-template.coffee` will be exported into `window.vtex.common.appendTemplate`.

## Importing with webpack

If your project uses webpack, you can `require` the dependencies from the window via [webpack externals](http://webpack.github.io/docs/library-and-externals.html) configuration.

For example:

    externals: {
        // require("appendTemplate") is external and available
        //  on the global var window.vtex.common.appendTemplate
        "appendTemplate": "window.vtex.common.appendTemplate"
    }


### Common

### Knockout

### Angular

### Underscore

`underscore-extensions` extends the global `_` with new utilitary functions.



------

VTEX - 2015
