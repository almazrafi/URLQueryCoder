import Foundation

public final class URLQueryEncoder {

    public static let `default` = URLQueryEncoder()

    public var dateEncodingStrategy: URLQueryDateEncodingStrategy
    public var dataEncodingStrategy: URLQueryDataEncodingStrategy
    public var nonConformingFloatEncodingStrategy: URLQueryNonConformingFloatEncodingStrategy
    public var boolEncodingStrategy: URLQueryBoolEncodingStrategy
    public var arrayEncodingStrategy: URLQueryArrayEncodingStrategy
    public var spaceEncodingStrategy: URLQuerySpaceEncodingStrategy
    public var keyEncodingStrategy: URLQueryKeyEncodingStrategy
    public var userInfo: [CodingUserInfoKey: Any]

    public init(
        dateEncodingStrategy: URLQueryDateEncodingStrategy = .deferredToDate,
        dataEncodingStrategy: URLQueryDataEncodingStrategy = .base64,
        nonConformingFloatEncodingStrategy: URLQueryNonConformingFloatEncodingStrategy = .throw,
        boolEncodingStrategy: URLQueryBoolEncodingStrategy = .literal,
        arrayEncodingStrategy: URLQueryArrayEncodingStrategy = .enumerated,
        spaceEncodingStrategy: URLQuerySpaceEncodingStrategy = .percentEscaped,
        keyEncodingStrategy: URLQueryKeyEncodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.dateEncodingStrategy = dateEncodingStrategy
        self.dataEncodingStrategy = dataEncodingStrategy
        self.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
        self.boolEncodingStrategy = boolEncodingStrategy
        self.arrayEncodingStrategy = arrayEncodingStrategy
        self.spaceEncodingStrategy = spaceEncodingStrategy
        self.keyEncodingStrategy = keyEncodingStrategy
        self.userInfo = userInfo
    }

    public func encode<T: Encodable>(_ value: T) throws -> String {
        let options = URLQueryEncodingOptions(
            dateEncodingStrategy: dateEncodingStrategy,
            dataEncodingStrategy: dataEncodingStrategy,
            nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy,
            boolEncodingStrategy: boolEncodingStrategy,
            arrayEncodingStrategy: arrayEncodingStrategy,
            spaceEncodingStrategy: spaceEncodingStrategy,
            keyEncodingStrategy: keyEncodingStrategy
        )

        let encoder = URLQuerySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: []
        )

        try value.encode(to: encoder)

        guard case let .dictionary(urlEncodedForm) = encoder.resolveValue() else {
            let errorContext = EncodingError.Context(
                codingPath: [],
                debugDescription: "Root component cannot be encoded in URL"
            )

            throw EncodingError.invalidValue(value, errorContext)
        }

        let serializer = URLQuerySerializer(
            arrayEncodingStrategy: arrayEncodingStrategy,
            spaceEncodingStrategy: spaceEncodingStrategy
        )

        return serializer.serialize(urlEncodedForm)
    }
}
