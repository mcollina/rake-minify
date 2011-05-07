Feature: Compile minify and bundle CoffeeScript files
  In order to build awesome javascript applications
  A ruby programmer
  Wants to minify its coffeescripts using rake

  Scenario: Minify single coffeescript 
    Given we want to add the file "c-a.coffee" into "c-a-wrapped.min.js"
    When I run rake minify
    Then "c-a-wrapped.min.js" should be minified

  Scenario: Combine multiple coffeescripts into a single file
    Given we want to add the file "c-a.coffee" into "app.js" with options:
      | minify | false |
    And we want to add the file "b.js" into "app.js" with options:
      | minify | false |
    When I run rake minify
    Then "app.js" should include "c-a.js" and "b.js"

  Scenario: Minify single javascript in bare mode
    Given we want to add the file "c-a.coffee" into "c-a-bare.min.js" with options:
      | bare | true  |
    When I run rake minify
    Then "c-a-bare.min.js" should be minified

  Scenario: Minify single javascript in wrapped mode
    Given we want to add the file "c-a.coffee" into "c-a-wrapped.min.js" with options:
      | bare | false |
    When I run rake minify
    Then "c-a-wrapped.min.js" should be minified

  Scenario: Combine multiple coffeescripts into a single file in bare mode
    Given we want to add the file "c-a.coffee" into "app.js" with options:
      | bare | true  |
    And we want to add the file "b.js" into "app.js" with options:
      | minify | false |
    When I run rake minify
    Then "app.js" should include "c-a-bare.js" and "b.js"

  Scenario: Combine multiple coffeescripts into a single file in wrapped mode
    Given we want to add the file "c-a.coffee" into "app.js" with options:
      | bare   | false |
      | minify | false |
    And we want to add the file "b.js" into "app.js" with options:
      | minify | false |
    When I run rake minify
    Then "app.js" should include "c-a-wrapped.js" and "b.js"
