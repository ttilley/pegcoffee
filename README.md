pegcoffee
=========

[![Build Status](https://travis-ci.org/ttilley/pegcoffee.png)](https://travis-ci.org/ttilley/pegcoffee)

pegcoffee is a PEG.js plugin for the post-0.7 plugin API that enables the use
of CoffeeScript instead of JavaScript in your grammar files. Additionally, your
code is given its own scope (the semi-hidden `peg$coffee$scope` object), giving
`@` or `this` much more intuitive behavior. You do not need to abuse the global
scope to share state across actions and predicates, and coffee will safely
scope any other variables to be local to the function.

To use from the console:
```
pegcoffee /path/to/grammar.pegcoffee
```

To use it via the API, you'd do something to the effect of:
```coffee
PEG = require 'pegjs'
pegcoffee = require 'pegcoffee'
parser = PEG.buildParser "some grammar string",
  output: 'source'
  optimize: 'speed'
  plugins: [pegcoffee]
console.log parser
```
