# Cache
![CI](https://github.com/grsouza/swift-cache/workflows/CI/badge.svg)

A Swifty wrapper around NSCache type.

## Installation

`Cache` is distributed using [Swift Package Manager](https://swift.org/package-manager/). To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(name: "Cache", url: "https://github.com/grsouza/swift-cache.git", from: "1.0.0")
    ],
    ...
)
```

Then import Cache wherever you'd like to use it:

```swift
import Cache
```

## Basic usage

Take a look at the [implementation](/Sources/Cache/Cache.swift), for more in-depth detail.


### Creating a Cache object
```swift
// This is a Cache with Strings as Keys and Int as values.
let cache = Cache<String, Int>()

// You can customize some aspects of the cache.
cache.name = "My cache"

// maximum number of values in cache
cache.countLimit = 10 

// total cost of the values in cache
cache.totalCostLimit = 100

// observe when a value will be evicted from cache.
cache.willEvictValue = { value in 
    print("\(value) is being evicted.")
}
```

### Inserting values in cache
```swift
cache.setValue(0, forKey: "A string")

// Or associate a cost with the key-pair
cache.setValue(100, forKey: "my-key", cost: 10)
```

### Retrieving value
```swift
let value = cache.value(forKey: "my-key")
// value is Optional<Int>
```

### Removing value
```swift
// Remove a value
cache.removeValue(forKey: "A string")

// Empties the cache
cache.removeAllValues()
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://github.com/grsouza/swift-cache/blob/master/LICENSE)
