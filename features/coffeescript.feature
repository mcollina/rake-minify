Feature: Compile minify and bundle CoffeeScript files
  In order to build awesome javascript applications
  A ruby programmer
  Wants to minify its coffeescripts using rake

  Scenario: Minify single javascript
    Given we want to minify the js file "c-a.coffee" into "c-a.min.js"
    When I run rake minify
    Then "c-a.min.js" should be minified

  Scenario: Combine multiple javascripts into a single file
    Given we want to combine the js file "c-a.coffee" into "app.js"
    And we want to combine the js file "b.js" into "app.js"
    When I run rake minify
    Then "app.js" should include "c-a.js" and "b.js"
