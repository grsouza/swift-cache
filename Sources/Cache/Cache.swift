import Foundation

/// `NSCache` swifty wrapper.
public struct Cache<Key: Hashable, Value> {

  // MARK: Lifecycle

  public init() {
    cache.delegate = delegate
  }

  // MARK: Public

  /// The name of the cache.
  ///
  /// The default value is an empty string ("").
  public var name: String {
    get { cache.name }
    set { cache.name = newValue }
  }

  /// The maximum number of objects the cache should hold.
  ///
  /// If 0, there is no count limit. The default value is 0.
  ///
  /// This is not a strict limit—if the cache goes over the limit, an object in the cache could be evicted instantly, later, or possibly never, depending on the implementation details of the cache.
  public var countLimit: Int {
    get { cache.countLimit }
    set { cache.countLimit = newValue }
  }

  /// The maximum total cost that the cache can hold before it starts evicting objects.
  ///
  /// If 0, there is no total cost limit. The default value is 0.
  ///
  /// When you add an object to the cache, you may pass in a specified cost for the object, such as the size in bytes of the object. If adding this object to the cache causes the cache’s total cost to rise above `totalCostLimit`, the cache may automatically evict objects until its total cost falls below `totalCostLimit`. The order in which the cache evicts objects is not guaranteed.
  ///
  /// This is not a strict limit, and if the cache goes over the limit, an object in the cache could be evicted instantly, at a later point in time, or possibly never, all depending on the implementation details of the cache.
  public var totalCostLimit: Int {
    get { cache.totalCostLimit }
    set { cache.totalCostLimit = newValue }
  }

  /// Called when a value is about to be evicted or removed from the cache.
  public var willEvictValue: ((Value) -> Void)? {
    get { delegate.willEvictValue }
    set { delegate.willEvictValue = newValue }
  }

  /// Sets the value of the specified key in the cache.
  /// - Parameters:
  ///   - value: The value to be stored in the cache.
  ///   - key: The key with which to associate the value.
  ///
  /// A cache does not copy the key values that are put into it.
  public func setValue(_ value: Value, forKey key: Key) {
    let entry = Entry(value)
    cache.setObject(entry, forKey: WrappedKey(key))
  }

  /// Sets the value of the specified key in the cache, and associates the key-value pair with the specified cost.
  /// - Parameters:
  ///   - value: The value to store in the cache.
  ///   - key: The key with which to associate the value.
  ///   - cost: The cost with which to associate the key-value pair.
  ///
  /// The `cost` value is used to compute a sum encompassing the costs of all the objects in the cache. When memory is limited or when the total cost of the cache eclipses the maximum allowed total cost, the cache could begin an eviction process to remove some of its elements. However, this eviction process is not in a guaranteed order. As a consequence, if you try to manipulate the cost values to achieve some specific behavior, the consequences could be detrimental to your program. Typically, the obvious cost is the size of the value in bytes. If that information is not readily available, you should not go through the trouble of trying to compute it, as doing so will drive up the cost of using the cache. Pass in `0` for the cost value if you otherwise have nothing useful to pass, or simply use the `setVakye:forKey:` method, which does not require a `cost` value to be passed in.
  ///
  /// A cache does not copy the key values that are put into it.
  public func setValue(_ value: Value, forKey key: Key, cost: Int) {
    let entry = Entry(value)
    cache.setObject(entry, forKey: WrappedKey(key), cost: cost)
  }

  /// Returns the value associated with a given key.
  /// - Parameter key: A key identifying the value.
  /// - Returns: The value associated with `key`, or `nil` if no value is associated with key.
  public func value(forKey key: Key) -> Value? {
    let entry = cache.object(forKey: WrappedKey(key))
    return entry?.value
  }

  /// Removes the value of the specified key in the cache.
  /// - Parameter key: The key identifying the value to be removed.
  public func removeValue(forKey key: Key) {
    cache.removeObject(forKey: WrappedKey(key))
  }

  /// Empties the cache.
  public func removeAllValues() {
    cache.removeAllObjects()
  }

  // MARK: Private

  private let cache = NSCache<WrappedKey, Entry>()
  private let delegate = Delegate()
}

private extension Cache {
  final class WrappedKey: NSObject {

    // MARK: Lifecycle

    init(_ key: Key) {
      self.key = key
    }

    // MARK: Internal

    let key: Key

    override var hash: Int { key.hashValue }

    override func isEqual(_ object: Any?) -> Bool {
      guard let value = object as? WrappedKey else {
        return false
      }

      return value.key == key
    }
  }

  final class Entry {

    // MARK: Lifecycle

    init(_ value: Value) {
      self.value = value
    }

    // MARK: Internal

    let value: Value

  }

  final class Delegate: NSObject, NSCacheDelegate {
    var willEvictValue: ((Value) -> Void)?

    func cache(_: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
      guard let entry = obj as? Entry else {
        return
      }

      willEvictValue?(entry.value)
    }
  }
}
