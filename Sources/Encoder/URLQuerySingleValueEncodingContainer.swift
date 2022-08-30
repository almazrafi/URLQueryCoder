import Foundation

internal final class URLQuerySingleValueEncodingContainer: URLQueryValueEncoding {

    private var value: URLQueryValueForm?

    internal let options: URLQueryEncodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal init(
        options: URLQueryEncodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    private func collectValue(_ encodedValue: URLQueryValueForm, for value: Any?) throws {
        guard self.value == nil else {
            let errorContext = EncodingError.Context(
                codingPath: codingPath,
                debugDescription: "Single value container already has encoded value."
            )

            throw EncodingError.invalidValue(value as Any, errorContext)
        }

        self.value = encodedValue
    }
}

extension URLQuerySingleValueEncodingContainer: SingleValueEncodingContainer {

    internal func encodeNil() throws {
        try collectValue(encodeNil(), for: nil)
    }

    internal func encode(_ value: String) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: Bool) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: Int) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: Int8) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: Int16) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: Int32) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: Int64) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: UInt) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: UInt8) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: UInt16) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: UInt32) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: UInt64) throws {
        try collectValue(encodeValue(value), for: value)
    }

    internal func encode(_ value: Double) throws {
        try collectValue(try encodeValue(value, at: codingPath), for: value)
    }

    internal func encode(_ value: Float) throws {
        try collectValue(try encodeValue(value, at: codingPath), for: value)
    }

    internal func encode<T: Encodable>(_ value: T) throws {
        try collectValue(try encodeValue(value, at: codingPath), for: value)
    }
}

extension URLQuerySingleValueEncodingContainer: Encoder {

    internal func container<Key: CodingKey>(keyedBy keyType: Key.Type) -> KeyedEncodingContainer<Key> {
        if case let .resolver(container as URLQueryAnyKeyedEncodingContainer) = value {
            return KeyedEncodingContainer(
                URLQueryKeyedEncodingContainer<Key>(container: container)
            )
        }

        let container = URLQueryAnyKeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        value = .resolver(container)

        return KeyedEncodingContainer(
            URLQueryKeyedEncodingContainer<Key>(container: container)
        )
    }

    internal func unkeyedContainer() -> UnkeyedEncodingContainer {
        if case let .resolver(container as URLQueryUnkeyedEncodingContainer) = value {
            return container
        }

        let container = URLQueryUnkeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        value = .resolver(container)

        return container
    }

    internal func singleValueContainer() -> SingleValueEncodingContainer {
        self
    }
}

extension URLQuerySingleValueEncodingContainer: URLQueryValueResolver {

    internal func resolveValue() -> URLQueryValue? {
        value?.resolveValue()
    }
}
