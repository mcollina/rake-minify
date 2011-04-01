Feature: Rake Interface
  In order to build a well structured Rakefile
  A ruby programmer
  Wants to customize the minify task 

  Background:
    Given we want to minify the js file "a.js" into "a.min.js"

  Scenario: Custom name for the task
    Given I have configured rake to minify at the ":my_minify" command
    When I run rake "my_minify"
    Then "a.min.js" should be minified

  Scenario: Prerequisites for the task
    Given I have a ":pre" rake task
    And I have configured rake to minify at the ":my_minify => :pre" command
    When I run rake "my_minify"
    Then "a.min.js" should be minified
