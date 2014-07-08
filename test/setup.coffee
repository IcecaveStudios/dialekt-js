global.chai = require 'chai'
global.sinon = require 'sinon'
global.assert = chai.assert


# mocha --compilers coffee:coffee-script --require test/coverageTest.coffee --reporter html-cov > coverage.html && open coverage.html
require("coffee-coverage").register
  path: "none" # sets the amouth of path you see in output none = user.coffee, abbr = s/c/m/user.coffe, full = src/client/model/user.coffee
  basePath: __dirname + "/../src" #go up to webclient root directory
  # initAll: true #uncomment if you want to see all files no just files required() in tests
