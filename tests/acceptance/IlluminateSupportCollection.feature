Feature: Collections
  In order to use Laravel Collections safely
  As a Psalm user
  I need Psalm to typecheck collections

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm totallyTyped="true">
        <projectFiles>
          <directory name="."/>
        </projectFiles>
        <plugins>
          <pluginClass class="Fkupper\Psalm\LaravelCollection\Plugin" />
        </plugins>
      </psalm>
      """
    And I have the following code preamble
      """
      <?php
      use Illuminate\Support\Collection;
      """

  @Collection::add
  Scenario: Adding an item of invalid type to the collection
    Given I have the following code
      """
      /** @var Collection<int,string> */
      $c = new Collection(["a", "b", "c"]);
      $c->add(1);
      """
    When I run Psalm
    Then I see these errors
      | Type                  | Message                                                                                   |
      | InvalidScalarArgument | Foo message |
    And I see no other errors
