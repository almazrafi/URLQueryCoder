import Foundation

internal final class URLQueryAnyKeyedEncodingContainer {

    private var dictionary: [String: URLQueryValueForm] = [:]

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

    private func encodeKey<Key: CodingKey>(_ key: Key) -> String {
        switch options.keyEncodingStrategy {
        case .useDefaultKeys:
            return key.stringValue

        case let .custom(closure):
            return closure(codingPath.appending(key)).stringValue
        }
    }

    internal func collectValue<Key: CodingKey>(_ encodedValue: URLQueryValueForm, forKey key: Key) {
        dictionary[encodeKey(key)] = encodedValue
    }

    internal func nestedContainer<Key: CodingKey, NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) -> URLQueryAnyKeyedEncodingContainer {
        if case let .resolver(container as URLQueryAnyKeyedEncodingContainer) = dictionary[encodeKey(key)] {
            return container
        }

        let container = URLQueryAnyKeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(key)
        )

        collectValue(.resolver(container), forKey: key)

        return container
    }

    internal func nestedUnkeyedContainer<Key: CodingKey>(forKey key: Key) -> UnkeyedEncodingContainer {
        if case let .resolver(container as URLQueryUnkeyedEncodingContainer) = dictionary[encodeKey(key)] {
            return container
        }

        let container = URLQueryUnkeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(key)
        )

        collectValue(.resolver(container), forKey: key)

        return container
    }

    internal func superEncoder<Key: CodingKey>(forKey key: Key) -> Encoder {
        if case let .resolver(container as URLQuerySingleValueEncodingContainer) = dictionary[encodeKey(key)] {
            return container
        }

        let encoder = URLQuerySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(key)
        )

        collectValue(.resolver(encoder), forKey: key)

        return encoder
    }
}

extension URLQueryAnyKeyedEncodingContainer: URLQueryValueResolver {

    internal func resolveValue() -> URLQueryValue? {
        .dictionary(dictionary.compactMapValues { $0.resolveValue() })
    }
}
