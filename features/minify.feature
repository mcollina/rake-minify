Feature: Minify Javascripts 
  In order to build awesome javascript applications
  A ruby programmer
  Wants to minify its javascripts using rake

  Scenario: Minify single javascript
    Given we want to minify the js file "a.js" into "a.min.js"
    When I run rake minify
    Then "a.min.js" should be minified

  Scenario: Combine multiple javascripts into a single file
    Given we want to combine the js file "a.js" into "app.js"
    And we want to combine the js file "b.js" into "app.js"
    When I run rake minify
    Then "app.js" should include "a.js" and "b.js"

  Scenario: Minify multiple javascripts into a single file
    Given we want to minify the js file "a.js" into "app.min.js"
    And we want to minify the js file "b.js" into "app.min.js"
    When I run rake minify
    Then "app.min.js" should include "a.min.js" and "b.min.js"

  Scenario: Minify multiple javascripts into multiple files
    Given we want to minify the js file "a.js" into "app.min.js"
    And we want to minify the js file "b.js" into "app.min.js"
    And we want to minify the js file "a.js" into "a.min.js"
    When I run rake minify
    Then "app.min.js" should include "a.min.js" and "b.min.js"
    And "a.min.js" should be minified

  Scenario: Combine and minify only one js file
    Given we want to combine the js file "a.js" into "app.js"
    And we want to minify the js file "b.js" into "app.js"
    When I run rake minify
    Then "app.js" should include "a.js" and "b.min.js"

  Scenario: Minify single javascript with basedir
    Given the basedir "public"
    And we want to minify the js file "a.js" into "a.min.js"
    When I run rake minify
    Then "a.min.js" should be minified

  Scenario: Minify multiple javascripts with basedir
    Given the basedir "public"
    And we want to minify the js file "a.js" into "app.min.js"
    And we want to minify the js file "b.js" into "app.min.js"
    When I run rake minify
    Then "app.min.js" should include "a.min.js" and "b.min.js"

  @wip
  Scenario: Minify multiple javascripts with an inner directory
    Given the inner directory "public"
    And we want to minify the js file "a.js" into "app.min.js"
    And we want to minify the js file "b.js" into "app.min.js"
    When I run rake minify
    Then "app.min.js" should include "a.min.js" and "b.min.js"
