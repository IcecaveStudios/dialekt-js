# Dialekt for JavaScript

[![Build Status]](https://travis-ci.org/IcecaveStudios/dialekt-js)
[![Test Coverage]](https://coveralls.io/r/IcecaveStudios/dialekt-js?branch=develop)
[![SemVer]](http://semver.org)

**Dialekt** is a very simple language for representing boolean expressions of the form often used by search engines.

* Read the [API documentation](http://icecavestudios.github.io/dialekt-js/)
* Try the [online demo](http://dialekt.icecave.com.au)

This is a JavaScript port of the [original PHP package](https://github.com/IcecaveStudios/dialekt).


### To use
* npm install dialekt-js --save
or 
* git clone
* npm install
* npm run build (generates js)
* npm link or use files in lib/
* npm link dialekt-js (in from dependant project)


### Contribute
* fork then clone
* npm install
* modify .coffee
* mocha (for coverage: mocha --reporter html-cov > coverage.html)
* npm run build (generates js)



### Generate Docs
* clone
* npm install
* grunt codo (generates docs/)
* grunt gh-pages (commits new docs to gh-pages branch pushes them to upstream)



<!-- references -->
[Build Status]: http://img.shields.io/travis/IcecaveStudios/dialekt-js/develop.svg
[Test Coverage]: http://img.shields.io/coveralls/IcecaveStudios/dialekt-js/develop.svg
[SemVer]: http://img.shields.io/:semver-0.0.0-red.svg
