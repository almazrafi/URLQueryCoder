import Foundation

internal final class URLQueryKeyedEncodingContainer<Key: CodingKey>: URLQueryValueEncoding {

    internal let container: URLQueryAnyKeyedEncodingContainer

    internal var options: URLQueryEncodingOptions {
        container.options
    }

    internal var userInfo: [CodingUserInfoKey: Any] {
        container.userInfo
    }

    internal var codingPath: [CodingKey] {
        container.codingPath
    }

    internal init(container: URLQueryAnyKeyedEncodingContainer) {
        self.container = container
    }
}

extension URLQueryKeyedEncodingContainer: KeyedEncodingContainerProtocol {

    internal func encodeNil(forKey key: Key) throws {
        container.collectValue(encodeNil(), forKey: key)
    }

    internal func encode(_ value: String, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: Bool, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: Int, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: Int8, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: Int16, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: Int32, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: Int64, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: UInt, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: UInt8, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: UInt16, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: UInt32, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: UInt64, forKey key: Key) throws {
        container.collectValue(encodeValue(value), forKey: key)
    }

    internal func encode(_ value: Double, forKey key: Key) throws {
        container.collectValue(try encodeValue(value, at: codingPath.appending(key)), forKey: key)
    }

    internal func encode(_ value: Float, forKey key: Key) throws {
        container.collectValue(try encodeValue(value, at: codingPath.appending(key)), forKey: key)
    }

    internal func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        container.collectValue(try encodeValue(value, at: codingPath.appending(key)), forKey: key)
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) -> KeyedEncodingContainer<NestedKey> {
        let container = self.container.nestedContainer(keyedBy: keyType, forKey: key)

        return KeyedEncodingContainer(
            URLQueryKeyedEncodingContainer<NestedKey>(container: container)
        )
    }

    internal func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        container.nestedUnkeyedContainer(forKey: key)
    }

    internal func superEncoder(forKey key: Key) -> Encoder {
        container.superEncoder(forKey: key)
    }

    internal func superEncoder() -> Encoder {
        container.superEncoder(forKey: AnyCodingKey.super)
    }
}
