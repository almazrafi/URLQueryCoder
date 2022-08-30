import Foundation

internal protocol URLQueryValueDecoding {

    var options: URLQueryDecodingOptions { get }
    var userInfo: [CodingUserInfoKey: Any] { get }
}

extension URLQueryValueDecoding {

    private func decodeString(
        _ value: URLQueryValue?,
        at codingPath: [CodingKey]
    ) throws -> String {
        guard let value = value?.string else {
            throw DecodingError.invalidValue(
                value,
                of: String.self,
                at: codingPath
            )
        }

        return value
    }

    private func decodePrimitiveValue<T: Decodable & LosslessStringConvertible>(
        _ value: URLQueryValue?,
        at codingPath: [CodingKey]
    ) throws -> T {
        guard let value = T(try decodeString(value, at: codingPath)) else {
            throw DecodingError.invalidValue(value, of: T.self, at: codingPath)
        }

        return value
    }

    private func decodeNonPrimitiveValue<T: Decodable>(
        _ value: URLQueryValue?,
        of type: T.Type = T.self,
        at codingPath: [CodingKey]
    ) throws -> T {
        let decoder = URLQuerySingleValueDecodingContainer(
            value: value,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return try T(from: decoder)
    }

    private func decodeCustomizedValue<T: Decodable>(
        _ value: URLQueryValue?,
        of type: T.Type = T.self,
        at codingPath: [CodingKey],
        using closure: (_ decoder: Decoder) throws -> T
    ) throws -> T {
        let decoder = URLQuerySingleValueDecodingContainer(
            value: value,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return try closure(decoder)
    }

    private func decodeBooleanValue(
        _ value: URLQueryValue?,
        at codingPath: [CodingKey]
    ) throws -> Bool {
        switch try decodeString(value, at: codingPath).lowercased() {
        case .urlQueryNumericTrue, .urlQueryLiteralTrue:
            return true

        case .urlQueryNumericFalse, .urlQueryLiteralFalse:
            return false

        default:
            throw DecodingError.invalidValue(value, of: Bool.self, at: codingPath)
        }
    }

    private func decodeFloatingPointValue<T: FloatingPoint & LosslessStringConvertible>(
        _ value: URLQueryValue?,
        of type: T.Type = T.self,
        at codingPath: [CodingKey]
    ) throws -> T {
        let rawValue = try decodeString(value, at: codingPath)

        if let value = T(rawValue) {
            return value
        }

        switch options.nonConformingFloatDecodingStrategy {
        case let .convertFromString(positiveInfinity, _, _) where rawValue == positiveInfinity:
            return T.infinity

        case let .convertFromString(_, negativeInfinity, _) where rawValue == negativeInfinity:
            return -T.infinity

        case let .convertFromString(_, _, nan) where rawValue == nan:
            return T.nan

        case .convertFromString, .throw:
            throw DecodingError.invalidValue(value, of: T.self, at: codingPath)
        }
    }

    private func decodeDate(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Date {
        switch options.dateDecodingStrategy {
        case .deferredToDate:
            return try decodeNonPrimitiveValue(value, at: codingPath)

        case .secondsSince1970:
            return Date(timeIntervalSince1970: try decodeFloatingPointValue(value, at: codingPath))

        case .millisecondsSince1970:
            return Date(timeIntervalSince1970: try decodeFloatingPointValue(value, at: codingPath) / 1000.0)

        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }

            let formattedDate = try decodeString(value, at: codingPath)

            guard let date = ISO8601DateFormatter().date(from: formattedDate) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Expected date string to be ISO8601-formatted."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return date

        case .formatted(let dateFormatter):
            let formattedDate = try decodeString(value, at: codingPath)

            guard let date = dateFormatter.date(from: formattedDate) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Date string does not match format expected by formatter."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return date

        case .custom(let closure):
            return try decodeCustomizedValue(value, at: codingPath, using: closure)
        }
    }

    private func decodeData(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Data {
        switch options.dataDecodingStrategy {
        case .deferredToData:
            return try decodeNonPrimitiveValue(value, at: codingPath)

        case .base64:
            let base64EncodedString = try decodeString(value, at: codingPath)

            guard let data = Data(base64Encoded: base64EncodedString) else {
                let errorContext = DecodingError.Context(
                    codingPath: codingPath,
                    debugDescription: "Encountered Data is not valid Base64."
                )

                throw DecodingError.dataCorrupted(errorContext)
            }

            return data

        case .custom(let closure):
            return try decodeCustomizedValue(value, at: codingPath, using: closure)
        }
    }

    private func decodeURL(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> URL {
        guard let url = URL(string: try decodeString(value, at: codingPath)) else {
            let errorContext = DecodingError.Context(
                codingPath: codingPath,
                debugDescription: "String is not valid URL."
            )

            throw DecodingError.dataCorrupted(errorContext)
        }

        return url
    }
}

extension URLQueryValueDecoding {

    internal func decodeNil(_ value: URLQueryValue?) -> Bool {
        value.isNil
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> String {
        try decodeString(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Bool {
        try decodeBooleanValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Int {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Int8 {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Int16 {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Int32 {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Int64 {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> UInt {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> UInt8 {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> UInt16 {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> UInt32 {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> UInt64 {
        try decodePrimitiveValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Double {
        try decodeFloatingPointValue(value, at: codingPath)
    }

    internal func decodeValue(_ value: URLQueryValue?, at codingPath: [CodingKey]) throws -> Float {
        try decodeFloatingPointValue(value, at: codingPath)
    }

    internal func decodeValue<T: Decodable>(
        _ value: URLQueryValue?,
        at codingPath: [CodingKey],
        of type: T.Type
    ) throws -> T {
        switch T.self {
        case is URL.Type:
            return try decodeURL(value, at: codingPath) as! T

        case is Date.Type:
            return try decodeDate(value, at: codingPath) as! T

        case is Data.Type:
            return try decodeData(value, at: codingPath) as! T

        default:
            return try decodeNonPrimitiveValue(value, at: codingPath)
        }
    }
}

private extension DecodingError {

    static func invalidValue(
        _ component: URLQueryValue?,
        of type: Any.Type,
        at codingPath: [CodingKey]
    ) -> DecodingError {
        let componentDescription = component == nil
            ? "nil"
            : "invalid"

        let context = DecodingError.Context(
            codingPath: codingPath,
            debugDescription: "Expected to decode \(type) but the value is \(componentDescription)."
        )

        return .typeMismatch(type, context)
    }
}
