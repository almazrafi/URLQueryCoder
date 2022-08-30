import Foundation

internal final class URLQueryKeyedDecodingContainer<Key: CodingKey>: URLQueryValueDecoding {

    internal let dictionary: [String: URLQueryValue]
    internal let options: URLQueryDecodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal init(
        dictionary: [String: URLQueryValue],
        options: URLQueryDecodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        switch options.keyDecodingStrategy {
        case .useDefaultKeys:
            self.dictionary = dictionary

        case let .custom(closure):
            let keysAndValues = dictionary.map { key, value in
                (closure(codingPath.appending(AnyCodingKey(key))).stringValue, value)
            }

            self.dictionary = Dictionary(keysAndValues) { $1 }
        }

        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    private func value<T>(forKey key: Key, of type: T.Type = T.self) throws -> T {
        let anyValue = dictionary[key.stringValue]

        guard let value = anyValue as? T else {
            throw DecodingError.invalidValue(
                anyValue,
                forKey: key,
                at: codingPath.appending(key),
                expectation: type
            )
        }

        return value
    }

    private func superDecoder(forAnyKey key: CodingKey) throws -> Decoder {
        let decoder = URLQuerySingleValueDecodingContainer(
            value: dictionary[key.stringValue],
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(key)
        )

        return decoder
    }
}

extension URLQueryKeyedDecodingContainer: KeyedDecodingContainerProtocol {

    internal var allKeys: [Key] {
        dictionary.keys.compactMap { Key(stringValue: $0) }
    }

    internal func contains(_ key: Key) -> Bool {
        dictionary.contains { $0.key == key.stringValue }
    }

    internal func decodeNil(forKey key: Key) throws -> Bool {
        decodeNil(try value(forKey: key))
    }

    internal func decode(_ type: String.Type, forKey key: Key) throws -> String {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key))
    }

    internal func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        try decodeValue(try value(forKey: key), at: codingPath.appending(key), of: type)
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey> {
        try superDecoder(forAnyKey: key).container(keyedBy: keyType)
    }

    internal func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        try superDecoder(forAnyKey: key).unkeyedContainer()
    }

    internal func superDecoder(forKey key: Key) throws -> Decoder {
        try superDecoder(forAnyKey: key)
    }

    internal func superDecoder() throws -> Decoder {
        try superDecoder(forAnyKey: AnyCodingKey.super)
    }
}

private extension DecodingError {

    static func invalidValue<Key: CodingKey>(
        _ value: Any?,
        forKey key: Key,
        at codingPath: [CodingKey],
        expectation: Any.Type
    ) -> Self {
        switch value {
        case let value?:
            let context = Context(
                codingPath: codingPath,
                debugDescription: "Expected to decode \(expectation) but found \(type(of: value)) instead."
            )

            return .typeMismatch(expectation, context)

        case nil:
            let context = Context(
                codingPath: codingPath,
                debugDescription: "No value associated with key \(key.stringValue)."
            )

            return .keyNotFound(key, context)
        }
    }
}
