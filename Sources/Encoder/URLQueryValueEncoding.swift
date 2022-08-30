import Foundation

internal protocol URLQueryValueEncoding {

    var options: URLQueryEncodingOptions { get }
    var userInfo: [CodingUserInfoKey: Any] { get }
}

extension URLQueryValueEncoding {

    private func encodeString(_ value: String) -> URLQueryValueForm {
        .value(.string(value))
    }

    private func encodePrimitiveValue<T: Encodable & LosslessStringConvertible>(
        _ value: T
    ) -> URLQueryValueForm {
        encodeString(String(value))
    }

    private func encodeNonPrimitiveValue<T: Encodable>(
        _ value: T,
        at codingPath: [CodingKey]
    ) throws -> URLQueryValueForm {
        let encoder = URLQuerySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        try value.encode(to: encoder)

        return .value(encoder.resolveValue())
    }

    private func encodeCustomizedValue<T: Encodable>(
        _ value: T,
        at codingPath: [CodingKey],
        closure: (_ value: T, _ encoder: Encoder) throws -> Void
    ) throws -> URLQueryValueForm {
        let encoder = URLQuerySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        try closure(value, encoder)

        return .value(encoder.resolveValue())
    }

    private func encodeBooleanValue(_ value: Bool) -> URLQueryValueForm {
        switch options.boolEncodingStrategy {
        case .numeric:
            return encodeString(value ? .urlQueryNumericTrue : .urlQueryNumericFalse)

        case .literal:
            return encodeString(value ? .urlQueryLiteralTrue : .urlQueryLiteralFalse)
        }
    }

    private func encodeFloatingPointValue<T: FloatingPoint & Encodable & LosslessStringConvertible>(
        _ value: T,
        at codingPath: [CodingKey]
    ) throws -> URLQueryValueForm {
        if value.isFinite {
            return encodePrimitiveValue(value)
        }

        switch options.nonConformingFloatEncodingStrategy {
        case let .convertToString(positiveInfinity, _, _) where value == T.infinity:
            return encodeString(positiveInfinity)

        case let .convertToString(_, negativeInfinity, _) where value == -T.infinity:
            return encodeString(negativeInfinity)

        case let .convertToString(_, _, nan):
            return encodeString(nan)

        case .throw:
            throw EncodingError.invalidFloatingPointValue(value, at: codingPath)
        }
    }

    private func encodeDate(_ date: Date, at codingPath: [CodingKey]) throws -> URLQueryValueForm {
        switch options.dateEncodingStrategy {
        case .deferredToDate:
            return try encodeNonPrimitiveValue(date, at: codingPath)

        case .millisecondsSince1970:
            return try encodeFloatingPointValue(date.timeIntervalSince1970 * 1000.0, at: codingPath)

        case .secondsSince1970:
            return try encodeFloatingPointValue(date.timeIntervalSince1970, at: codingPath)

        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }

            let formattedDate = ISO8601DateFormatter.string(
                from: date,
                timeZone: .iso8601,
                formatOptions: .withInternetDateTime
            )

            return encodeString(formattedDate)

        case let .formatted(dateFormatter):
            return encodeString(dateFormatter.string(from: date))

        case let .custom(closure):
            return try encodeCustomizedValue(date, at: codingPath, closure: closure)
        }
    }

    private func encodeData(_ data: Data, at codingPath: [CodingKey]) throws -> URLQueryValueForm {
        switch options.dataEncodingStrategy {
        case .deferredToData:
            return try encodeNonPrimitiveValue(data, at: codingPath)

        case .base64:
            return encodeString(data.base64EncodedString())

        case let .custom(closure):
            return try encodeCustomizedValue(data, at: codingPath, closure: closure)
        }
    }

    private func encodeURL(_ url: URL) -> URLQueryValueForm {
        encodeString(url.absoluteString)
    }
}

extension URLQueryValueEncoding {

    internal func encodeNil() -> URLQueryValueForm {
        .value(nil)
    }

    internal func encodeValue(_ value: String) -> URLQueryValueForm {
        encodeString(value)
    }

    internal func encodeValue(_ value: Bool) -> URLQueryValueForm {
        encodeBooleanValue(value)
    }

    internal func encodeValue(_ value: Int) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: Int8) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: Int16) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: Int32) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: Int64) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: UInt) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: UInt8) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: UInt16) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: UInt32) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: UInt64) -> URLQueryValueForm {
        encodePrimitiveValue(value)
    }

    internal func encodeValue(_ value: Double, at codingPath: [CodingKey]) throws -> URLQueryValueForm {
        try encodeFloatingPointValue(value, at: codingPath)
    }

    internal func encodeValue(_ value: Float, at codingPath: [CodingKey]) throws -> URLQueryValueForm {
        try encodeFloatingPointValue(value, at: codingPath)
    }

    internal func encodeValue<T: Encodable>(
        _ value: T,
        at codingPath: [CodingKey]
    ) throws -> URLQueryValueForm {
        switch value {
        case let url as URL:
            return encodeURL(url)

        case let date as Date:
            return try encodeDate(date, at: codingPath)

        case let data as Data:
            return try encodeData(data, at: codingPath)

        default:
            return try encodeNonPrimitiveValue(value, at: codingPath)
        }
    }
}

private extension EncodingError {

    static func invalidFloatingPointValue<T: FloatingPoint>(_ value: T, at codingPath: [CodingKey]) -> EncodingError {
        let valueDescription: String

        switch value {
        case T.infinity:
            valueDescription = "\(T.self).infinity"

        case -T.infinity:
            valueDescription = "-\(T.self).infinity"

        default:
            valueDescription = "\(T.self).nan"
        }

        let debugDescription = """
            Unable to encode \(valueDescription) directly in URL query.
            Use URLQueryNonConformingFloatEncodingStrategy.convertToString to specify how the value should be encoded.
            """

        return .invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: debugDescription))
    }
}
