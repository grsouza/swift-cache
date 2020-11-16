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

Just instantiate a new Cache object and use `setValue(_:forKey:)`, `value(forKey:)` and `removeValue(forKey:)` for manipulating the cache. There are some configuration properties that can be set on the cache type, for example  the maximum number of items that cache holds.

Take a look at the [implementation](/Sources/Cache/Cache.swift), there are plenty of documentations there.

```swift
let cache = Cache<String, Int>() 

cache.setValue(0, forKey: "A string")

let value = cache.value(forKey: "A string")

cache.removeValue(forKey: "A string")

cache.removeAllValues()
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://github.com/grsouza/swift-cache/blob/master/LICENSE)
