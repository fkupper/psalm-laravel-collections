# psalm-laravel-collections
[![Build Status](https://travis-ci.org/fkupper/psalm-laravel-collections.svg?branch=master)](https://travis-ci.org/fkupper/psalm-laravel-collections)
[![Total Downloads](https://poser.pugx.org/fkupper/psalm-laravel-collections/downloads)](//packagist.org/packages/fkupper/psalm-laravel-collections)
[![Monthly Downloads](https://poser.pugx.org/fkupper/psalm-laravel-collections/d/monthly)](//packagist.org/packages/fkupper/psalm-laravel-collections)

A [Laravel](https://github.com/laravel/laravel)'s `\Illuminate\Support\Collection` plugin for [Psalm](https://github.com/vimeo/psalm) (requires Psalm v3) to help you find errors in some cases where you use collections.

## Installation:

```console
$ composer require --dev fkupper/psalm-laravel-collections
$ vendor/bin/psalm-plugin enable fkupper/psalm-laravel-collections
```

## Examples

### Accessing array with wrong key type
```php
/** @var Collection<string,string> */
$c = new Collection(['a' => 'A', 'b' => 'B', 'c' => 'C']);
$items = $c->all();
$items[1];
```

### Adding an item of invalid type
```php
/** @var Collection<int,string> */
$c = new Collection(["a", "b", "c"]);
// items type is deinfed as string, cannot add int
$c->add(1);
```

### Asserting collection item value type
```php
/**
 * @param Collection<string,\Exception>
 */
function(Collection $coll): void {
    $exception = $coll->first();
    // psalm will report this typo
    $exception->getMassage();
}

/**
 * @param Collection<int,string>
 */
function(Collection $coll): int {
    $value = $coll->first();
    // psalm will remind you forgot to cast that $value to int
    return $value + 1;
}
```

### Better assertion of helper methods, like `Collection::filter`
```php
/**
 * This function is using wrong types in the filter Closure params.
 * @param Collection<int,string>
 */
function(Collection $coll): void {
    $filteredValues = $coll->filter(
        // psalm will tell you that the Closure params are wrong
        function (bool $value, float $key): bool {
            return true;
        }
    )
}

/**
 * @param Collection<int,string>
 */
function(Collection $coll): void {
    $filteredValues = $coll->filter(
        function (int $value, string $key): bool {
            return true;
        }
    )
    // psalm understands that the result of the filter call
    // is a collection of same type as it was before, so the value
    // type is still string, therefore array cannot be added
    $filteredValues->add(['something']);
}
```

## Work In Progress

This is a work in progress project, therefore not all Collection methods have had their templates extended, or tested.

Please report any issues you may find, and even beetter, make a pull request with a fix!