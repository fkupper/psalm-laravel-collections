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

    @Collection::times
    Scenario: Adding an item of invalid type to the collection resulted of Collection::times
        Given I have the following code
            """
            $c = Collection::times(10, function (int $number): bool {
                return $number > 0;
            });
            $c->add(1);
            """
        When I run Psalm
        Then I see these errors
            | Type                  | Message                                                                          |
            | InvalidScalarArgument | Argument 1 of Illuminate\Support\Collection::add expects bool, 1 provided   |
        And I see no other errors

    @Collection::times
    Scenario: Adding an item of valid type to the collection resulted of Collection::times
        Given I have the following code
            """
            $c = Collection::times(10, function (int $number): bool {
                return $number > 0;
            });
            $c->add(true);
            """
        When I run Psalm
        And I see no other errors

    @Collection::all
    Scenario: Accessing collection array by key with invalid key type
        Given I have the following code
            """
            /** @var Collection<string,string> */
            $c = new Collection(['a' => 'A', 'b' => 'B', 'c' => 'C']);
            /** @psalm-suppress UnusedMethodCall */
            $c->all()[1];
            """
        When I run Psalm
        Then I see these errors
            | Type               | Message                                                                          |
            | InvalidArrayOffset | Cannot access value on variable  using offset value of 1, expecting string |
        And I see no other errors

    @Collection::all
    Scenario: Accessing collection array by key with valid key type
        Given I have the following code
            """
            /** @var Collection<string,string> */
            $c = new Collection(['a' => 'A', 'b' => 'B', 'c' => 'C']);
            /** @psalm-suppress UnusedMethodCall */
            $c->all()['a'];
            """
        When I run Psalm
        And I see no other errors

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
            | Type                  | Message                                                                          |
            | InvalidScalarArgument | Argument 1 of Illuminate\Support\Collection::add expects string, 1 provided |
        And I see no other errors

    @Collection::add
    Scenario: Adding an item of a valid type to the collection
        Given I have the following code
            """
            /** @var Collection<int,string> */
            $c = new Collection(["a", "b", "c"]);
            $c->add("d");
            """
        When I run Psalm
        Then I see no errors