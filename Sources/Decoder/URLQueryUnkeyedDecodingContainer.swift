import Foundation

internal final class URLQueryUnkeyedDecodingContainer: URLQueryValueDecoding {

    internal let array: [URLQueryValue?]
    internal let options: URLQueryDecodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal private(set) var currentIndex = 0

    internal var currentCodingPath: [CodingKey] {
        codingPath.appending(AnyCodingKey(currentIndex))
    }

    internal init(
        array: [Int: URLQueryValue],
        options: URLQueryDecodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        self.array = array
            .keys
            .max()
            .map { 0...Int($0) }?
            .map { array[$0] } ?? []

        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    private func popNextValue() throws -> URLQueryValue? {
        guard currentIndex < array.count else {
            let errorContext = DecodingError.Context(
                codingPath: currentCodingPath,
                debugDescription: "Unkeyed container is at end."
            )

            throw DecodingError.valueNotFound(Any.self, errorContext)
        }

        defer {
            currentIndex += 1
        }

        return array[currentIndex]
    }
}

extension URLQueryUnkeyedDecodingContainer: UnkeyedDecodingContainer {

    internal var count: Int? {
        array.count
    }

    internal var isAtEnd: Bool {
        currentIndex == count
    }

    internal func decodeNil() throws -> Bool {
        decodeNil(try popNextValue())
    }

    internal func decode(_ type: String.Type) throws -> String {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: Bool.Type) throws -> Bool {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: Int.Type) throws -> Int {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: Int8.Type) throws -> Int8 {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: Int16.Type) throws -> Int16 {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: Int32.Type) throws -> Int32 {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: Int64.Type) throws -> Int64 {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt.Type) throws -> UInt {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt8.Type) throws -> UInt8 {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt16.Type) throws -> UInt16 {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt32.Type) throws -> UInt32 {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: UInt64.Type) throws -> UInt64 {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: Double.Type) throws -> Double {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode(_ type: Float.Type) throws -> Float {
        try decodeValue(try popNextValue(), at: currentCodingPath)
    }

    internal func decode<T: Decodable>(_ type: T.Type) throws -> T {
        try decodeValue(try popNextValue(), at: currentCodingPath, of: type)
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type
    ) throws -> KeyedDecodingContainer<NestedKey> {
        try superDecoder().container(keyedBy: keyType)
    }

    internal func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        try superDecoder().unkeyedContainer()
    }

    internal func superDecoder() throws -> Decoder {
        URLQuerySingleValueDecodingContainer(
            value: try popNextValue(),
            options: options,
            userInfo: userInfo,
            codingPath: currentCodingPath
        )
    }
}
