import Foundation

internal final class URLQueryUnkeyedEncodingContainer: URLQueryValueEncoding {

    private var array: [URLQueryValueForm] = []

    internal let options: URLQueryEncodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal var currentCodingPath: [CodingKey] {
        codingPath.appending(AnyCodingKey(count))
    }

    internal init(
        options: URLQueryEncodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    private func collectValue(_ encodedValue: URLQueryValueForm) {
        array.append(encodedValue)
    }
}

extension URLQueryUnkeyedEncodingContainer: UnkeyedEncodingContainer {

    internal var count: Int {
        array.count
    }

    internal func encodeNil() throws {
        collectValue(encodeNil())
    }

    internal func encode(_ value: String) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: Bool) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: Int) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: Int8) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: Int16) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: Int32) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: Int64) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: UInt) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: UInt8) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: UInt16) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: UInt32) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: UInt64) throws {
        collectValue(encodeValue(value))
    }

    internal func encode(_ value: Double) throws {
        collectValue(try encodeValue(value, at: currentCodingPath))
    }

    internal func encode(_ value: Float) throws {
        collectValue(try encodeValue(value, at: currentCodingPath))
    }

    internal func encode<T: Encodable>(_ value: T) throws {
        collectValue(try encodeValue(value, at: currentCodingPath))
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        let container = URLQueryAnyKeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: currentCodingPath
        )

        collectValue(.resolver(container))

        return KeyedEncodingContainer(
            URLQueryKeyedEncodingContainer<NestedKey>(container: container)
        )
    }

    internal func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = URLQueryUnkeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: currentCodingPath
        )

        collectValue(.resolver(container))

        return container
    }

    internal func superEncoder() -> Encoder {
        let encoder = URLQuerySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: currentCodingPath
        )

        collectValue(.resolver(encoder))

        return encoder
    }
}

extension URLQueryUnkeyedEncodingContainer: URLQueryValueResolver {

    internal func resolveValue() -> URLQueryValue? {
        let array = array
            .enumerated()
            .map { (key: $0, value: $1.resolveValue()) }
            .reduce(into: [:]) { result, keyValue in
                result[keyValue.key] = keyValue.value
            }

        return .array(array)
    }
}
